from datetime import datetime
from typing import Any, Optional

import pendulum

from jobs.fromsecret import authdb
from types_db import (
    BusinessValueError,
    DataRow,
    TaskData
)
from validation import SchemaError
from .utils import _file_date

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

    def close(self) -> None:
        self.dbconn.close()

    def _write_row(self, values: DataRow) -> None:
        table = self.table
        col_names = f"({','.join(values.keys())})"
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
        time_rx: str | None = None,
        provider: str = None,
        idetl: int = None,   
        overwrite: bool = False,    
        **kwargs: Any,
    ) -> None:
        self.db = db
        self.provider = provider
        self.time_rx = time_rx
        self.table = table
        self.idetl = idetl
        self.overwrite = overwrite
        super().__init__(**kwargs)

    def open(self) -> None:
        self.dbconn, self.cursor = authdb(self.db)

    def close(self) ->None:
        self.dbconn.close()

    def log_meta(self, source_path:str, pull_ts: datetime) -> tuple[int,bool]:
        fname = str(source_path).split("@")[0]
        self.cursor.execute(
        "SELECT id, ingested, ingest_ts FROM e_meta WHERE FileSorgente like %s"
        ,f"{fname}%"
        )
        rs = self.cursor.fetchone()
        if rs:
            if self.overwrite:
                self.cursor.execute(
                    "UPDATE e_meta SET FileSorgente = %s, pull_ts = %s ingest_ts = %s WHERE id = %s",
                    str(source_path),
                    pull_ts,
                    datetime.now(),
                    rs.id
                )
            
            self.dbconn.commit()
            return rs.id, True
        
        file_date = _file_date(str(source_path))

        col_names = "(FileSorgente, DataFile, Ingest_ts, Pull_ts, Fornitore, IdETL)"
        placeholders = "VALUES(%s,%s,%s,%s,%s,%s)"
        insert_statement = f"INSERT INTO e_meta {col_names} {placeholders}"
        
        self.cursor.execute(
            insert_statement,
            str(source_path),
            file_date,
            datetime.now(),
            pull_ts,
            self.provider,
            self.feed,
            self.idetl,
        )
        meta_id = self.cursor.fetchone()[0]
        self.dbconn.commit()
        return meta_id, False
    
    def delete_row(self, meta_id:int) -> None:
        table = self.table
        delete_statement = f"DELETE FROM {table} WHERE meta_id = %s"
        self.cursor.execute(
            delete_statement,
            meta_id
        )
            
    def _source_path_and_ts(self, data: TaskData, source_path: Optional[str]) -> tuple[str, datetime]:
        if not source_path and "source_path" not in data["meta"]:
            raise ValueError(
                "Il source file per i dati deve; o essere presente nel meta di TaskData "
                "o specificato / overridato come argomento"
            )

        if source_path:
            _file_date(source_path)
            pull_ts = datetime.now()
        else:
            source_path = str(data["meta"]["source_path"])
            pull_ts = datetime.strptime(data["meta"]["timestamp"], "%Y-%m-%dT%H:%M:%S+00:00")

        return (source_path, pull_ts)

    def _write_row(self, meta_id: int, values: DataRow) -> None:
        table = self.table
        values["meta_id"] = meta_id
        col_names = f"({','.join(values.keys())})"
        placeholders = f"VALUES ({','.join(['%s' for _ in values.values()])})"
        _values = [values[c] for c in values]
        insert_statement = f"INSERT INTO {table} {col_names} {placeholders}"
        self.cursor.execute(insert_statement, _values)
    
    def write_row(
            self, msg_: DataRow, task_meta: dict[str, Any],
            is_ingested: bool, meta_id: int
    ) -> None:
        msg = msg_.copy()
        try:
            if is_ingested and self.overwrite:
                self.delete_row(meta_id)
            self._write_row(
                meta_id,
                msg,
            )
        except SchemaError as err:
            error_msg = str(err).replace("\n", " ")
            print(error_msg)

    def run(self, data:TaskData,source_path: str | None = None, overwrite: bool | None = None) -> None:
        task_meta = data["meta"].copy()
        task_meta["overridden_source_path"] = source_path
        source_path, pull_ts = self._source_path_and_ts(data, source_path)
        self.overwrite = overwrite if overwrite is not None else self.overwrite
        try:
            self.open()
            meta_id, is_ingested = self.log_meta(
                source_path,
                pull_ts,
                data["meta"]["sheet"] if "sheet" in data["meta"] and data["meta"]["sheet"] else "-",
            )
            if not is_ingested or (is_ingested and self.overwrite):
                for msg_ in data["data"]:
                    self.write_row(msg_, source_path, task_meta, is_ingested, meta_id)
            else:
                print(f"Skippo file già salvato: {source_path}")
            self.dbconn.commit()

        except Exception as exc:
            self.dbconn.rollback()
            print(f"Errore inatteso {exc.__class__} : {exc}. Processando il file (meta id): {meta_id}")
            raise exc
        finally:
            self.close()

