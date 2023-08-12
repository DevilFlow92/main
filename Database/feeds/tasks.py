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

class MassiveInsert:
    def __init__(
        self,
        db: str,
        table: str,
        **kwargs: Any,    
    ) -> None:
        self.db = db
        self.table = table
        super().__init__(**kwargs)
    
    def open(self) -> None:
        self.dbconn, self.cursor = authdb(self.db)

    def _write_row(self, values: DataRow) -> None:
        table = self.table
        col_names = f"([{'],['.join(values.keys())}])"
        col_names = col_names.replace('[','').replace(']','')
        placeholders = f"VALUES ({','.join(['%s' for _ in values.values()])})"
        _values = [values[c] for c in values]
        insert_statement = f"INSERT INTO {table} {col_names} {placeholders}"
        self.cursor.execute(insert_statement, _values)

    def write_row(self, msg_:DataRow, task_meta: dict[str,Any]) ->None:
        msg = msg_.copy()
        try:
            self._write_row(msg)
        except SchemaError as err:
            error_msg = str(err).replace("\n", " ")
            print(error_msg)
            raise err
        
    def run(self,data:TaskData) -> None:
        task_meta = data["meta"].copy()
        try:
            self.open()
            for msg_ in data["data"]:
                self.write_row(msg_, task_meta)
            self.dbconn.commit()
        except Exception as ex:
            self.dbconn.rollback()
            raise ex
        finally:
            self.close()

    def close(self) -> None:
        self.dbconn.close()
    

'''
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
        self.table = table
        self.idetl = idetl
        self.overwrite = overwrite
        super().__init__(**kwargs)

    def open(self) -> None:
        self.dbconn, self.cursor = authdb(self.db)

    def _write_row(
            self,
            meta_id: int,

    )

    def run(self, data:TaskData, file_date:str) -> None:
        if self.overwrite is True:
            query = f'UPDATE %s set FlagAttivo = 0 WHERE '
'''
