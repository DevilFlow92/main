import json
import os
import re
from collections import namedtuple
from datetime import date, datetime, timedelta
from decimal import Decimal as D
from typing import Any, Iterable, Optional, Set, Union, cast

import pendulum
import pymysql

from jobs.fromsecret import authdb
from jobs import ReadCsv, ReadCBI, ReadFixedWidth #,ReadExcel
from types_db import (
    BusinessValueError,
    AdditionalParams,
    DataRow,
    DBObject,
    ExtParams,
    MessageState,
    TaskData
)
from validation import Schema, SchemaError, FieldRule, RuleDict

from .utils import _file_date, _file_time

tz_rome = pendulum.timezone("Europe/Rome")  # type: ignore


def from_swift_tag(values: list[str], key: str, index: int, sep: str = "/") -> str:
    for obj in values:
        if obj[0 : len(key)] == key:
            return obj.split(sep)[index]
    raise BusinessValueError(f"Tag SWIFT malformato: {str(values)}")


def _eventually_rename_columns(msg: DataRow, schema: dict[str, FieldRule]) -> DataRow:
    if all([fr.ingest_column is None for fr in schema.values()]):
        return msg

    out_row: DataRow = {}
    for key, value in msg.items():
        if schema[key].ingest_column is not None:
            out_row[schema[key].ingest_column] = value  # type: ignore
        else:
            out_row[key] = value
    return out_row

#todo
#class ReadExcelDelivery:
#    """."""
#
#    def __init__(
#        self,
#        rule: RuleDict,
#        data_start_row: int,
#        path_label: str = "path",
#        headless: bool = False,
#        header_row: int | None = None,
#        duplicated_columns: bool = False,
#        fix_powerapp_columns: bool = False,
#        fix_dimensions: bool = True,
#        **kwargs: Any,
#    ) -> None:
#        self.rule = rule
#        self.data_start_row = data_start_row
#        self.path_label = path_label
#        self.headless = headless
#        self.header_row = header_row
#        self.duplicated_columns = duplicated_columns
#        self.fix_powerapp_columns = fix_powerapp_columns
#        self.fix_dimensions = fix_dimensions
#
#        super().__init__(**kwargs)
#
#    def run(self, data: DataRow, encoding: Optional[str] = None) -> list[TaskData]:  # type: ignore
#        output = []
#        for file_ in data["data"]:
#            filename = file_["path"].name
#            for regex, sheets in self.rule.items():
#                if re.search(regex, filename) is not None:
#                    for sheet in sheets:
#                        schema = self.rule[regex][sheet]
#                        output.append(
#                            ReadExcel(
#                                fields=schema.keys(),
#                                sheet_name=sheet,
#                                data_start_row=self.data_start_row,
#                                path_label=self.path_label,
#                                headless=self.headless,
#                                header_row=self.header_row,
#                                duplicated_columns=self.duplicated_columns,
#                                fix_powerapp_columns=self.fix_powerapp_columns,
#                                fix_dimensions=self.fix_dimensions,
#                                external_fields=tuple([f for f in schema.keys() if schema[f].external]),
#                            ).run(data=file_),
#                        )
#                    break
#            else:
#                error = f'Impossibile trovare una regola per il file {file_["path"].name}'
#                self.logger.warning(error)
#                return [{"data": [], "errors": [{"error": error, "source": file_["path"].name}], "meta": data["meta"]}]
#
#        return output


class ReadCsvDelivery():
    """."""

    def __init__(
        self,
        rule: RuleDict,
        headless: bool = False,
        encoding: str = "utf-8",
        skip_lines: int = 0,
        allow_missing_cols: bool = False,
        custom_nones: set[str] = set(),
        options: dict[str, str] = {},
        path_label: str = "path",
        **kwargs: Any,
    ) -> None:
        self.rule = rule
        self.headless = headless
        self.encoding = encoding
        self.skip_lines = skip_lines
        self.allow_missing_cols = allow_missing_cols
        self.custom_nones = custom_nones
        self.options = options
        self.path_label = path_label
        super().__init__(**kwargs)
    def run(self, data: DataRow, encoding: Optional[str] = None) -> TaskData:  # type: ignore
        filename = data["path"].name
        for regex in self.rule:
            if re.search(regex, filename) is not None:
                if "-" not in self.rule[regex]:
                    raise RuntimeError("La regola dei file csv deve avere un solo foglio '-'")
                schema = self.rule[regex]["-"]
                break
        else:
            error = f"Impossibile trovare una regola per il file {data['path']}"
            self.logger.warning(error)
            return {"data": [], "errors": [{"error": error, "source": data["path"]}], "meta": {}}

        output = ReadCsv(
            fields=schema.keys(),  # type: ignore
            headless=self.headless,
            encoding=self.encoding,
            skip_lines=self.skip_lines,
            allow_missing_cols=self.allow_missing_cols,
            custom_nones=self.custom_nones,
            options=self.options,
            path_label=self.path_label,
        ).run(data=data, encoding=encoding)

        return output


class IngestFeed:
    """Salva dati letti da una sorgente su db.

    Metadati relativi al momento dell'esecuzione e sorgente dei dati vengono salvati in una tabella comune 'E_Meta'

    Esempio:

    ```
    ingest = IngestFeed(
        db="il_db",
        provider="la_banca",
        feed="il_flusso",
        )
    ingest(data)
    ```
    """

    def __init__(
        self,
        db: str,
        table: str,
        provider: str = None,
        feed: str = None,
        idetl: int = None,
        overwrite: bool = False,       
        **kwargs: Any,
    ) -> None:
        self.db = db
        self.provider = provider
        self.feed = feed
        self.overwrite = overwrite
        self.table = table
        self.idetl = idetl
        super().__init__(**kwargs)

    def open(self) -> None:
        self.dbconn, self.cursor = authdb(self.db)

    def run(self, data:TaskData) -> None:
       '''ToDo.'''
