import csv
import re

from typing import Any, Iterator, Optional, Set, cast
from types_db import DataRow, ErrorRow, TaskData
from logger import LogLevel

def _apply_skip_lines(skip_lines, csvfile) -> Iterator[str]: 
    for _ in range(skip_lines):
        try:
            csvfile.readline()
        except StopIteration:
            raise ValueError(f"Not enough lines to skip (skip_lines={skip_lines})")

    return csvfile

class ReadCsv:
    """Legge i dati contenuti in un file CSV.

    Esempio:

    ```
    FILEPATH = "path/to/file.csv"
    task_dati = {
        "data":[
            {"path":FILEPATH}
        ],    
    }

    read = ReadCsv(
        # i nomi delle colonne che si vogliono recuperare
        fields=("nome", "cognome"),
        # opzionalmente l'encoding del file ( se diverso da 'utf-8' )
        encoding="cp-1252",
        )
    dati = read(task_dati)
    ```
    """

    def __init__(
        self,
        fields: tuple[str, ...],
        headless: bool = False,
        encoding: str = "utf-8",
        skip_lines: int = 0,
        allow_missing_cols: bool = False,
        custom_nones: Set[str] = set(),
        options: dict[str, str] = {},
        path_label: str = "source_path",
        **kwargs: Any,
    ) -> None:
        self.fieldnames = fields
        self.headless = headless
        self.encoding = encoding
        self.skip_lines = skip_lines
        self.allow_missing_cols = allow_missing_cols
        self.custom_nones = custom_nones
        self.options = options
        self.path_label = path_label
        super().__init__(**kwargs)

    def _clean(self, row: DataRow) -> DataRow:
        _row = dict(
            [
                (k, v if v not in self.custom_nones else None)
                for k, v in row.items()
                if k in self.fieldnames and v != "*_MISSING_COL_*"
            ]
        )
        diff = set(self.fieldnames).difference(set(_row.keys()))
        if diff and not self.allow_missing_cols:
            raise ValueError(f"Skipped row, missing required columns: {diff} in row: {row}")
        return _row

    def run(self, data: DataRow, encoding: Optional[str] = None) -> TaskData:  # type: ignore
        output, errors = [], []
        with open(data[self.path_label], encoding=encoding if encoding else self.encoding) as csvfile:
            input_rows = _apply_skip_lines(self.skip_lines, csvfile)
            reader = csv.DictReader(  # type: ignore
                input_rows,
                fieldnames=[f for f in self.fieldnames] if self.headless else None,
                restval="*_MISSING_COL_*" if not self.allow_missing_cols else None,
                **self.options,
            )
            try:
                for row in reader:
                    try:
                        output.append(self._clean(row))
                    except ValueError as exc:
                        errors.append(cast(ErrorRow, {"error": str(exc), "source": row}))
            except UnicodeDecodeError as exc:
                self.log.message(
                    f"Non riesco a leggere {data[self.path_label]} ({exc}), "
                    "setta l'encoding corretto con 'encoding=...' nella configurazione del Task.",
                    LogLevel.ERROR,
                )
                raise exc

            meta_dict = {k: v for k, v in data.items()}
            meta_dict["isEmpty"] = len(output) == 0
            meta_dict["sheet"] = "-"
            return {"data": output, "errors": errors, "meta": meta_dict}

class ReadFixedWidth:
    """
    Legge i dati di file a lunghezza fissa (senza separatori)
    
    Esempio:

    FILEPATH = "C:\ScriptAdminRoot\Execute\main\Database\\fixedwidth.txt"
    FIELDS = {
        "NAME": [0,24],
        "STATE": [24,37],
        "TELEPHONE": [37,48], 
    }
    task_dati = {
        "data":[
            {"path": FILEPATH},
        ],
    }
    read = ReadFixedWidth(
        fields=FIELDS,
        skip_lines=1,
        
    )
    dati = read.run(task_dati["data"][0])
    
    """
    def __init__(
        self,
        fields: dict[str, tuple[int, Optional[int]]],
        skip_lines: int = 0,
        encoding: str = "utf-8",
        allow_missing_cols: bool = True,
        path_label: str = "path",
        accept_line_re: list[str] = [],
        reject_line_re: list[str] = [],
        **kwargs: Any,
    ) -> None:
        self.fields = fields
        self.skip_lines = skip_lines
        self.encoding = encoding
        self.allow_missing_cols = allow_missing_cols
        self.path_label = path_label
        self.accept_line_re = accept_line_re
        self.reject_line_re = reject_line_re
        super().__init__(**kwargs)

    def run(self, data: DataRow) -> TaskData:  # type: ignore
        output, errors = [], []
        source_path = data[self.path_label]
        with open(source_path, encoding=self.encoding) as csvfile:
            input_rows = _apply_skip_lines(self.skip_lines, csvfile)
            for row in input_rows:
                try:
                    if self._parsable(row.strip()):
                        output.append(self._parse(row.strip()))
                except ValueError as exc:
                    errors.append(cast(ErrorRow, {"error": str(exc), "row": row}))

        meta_dict = {k: v for k, v in data.items()}
        meta_dict["isEmpty"] = len(output) == 0
        return {"data": output, "errors": errors, "meta": meta_dict}

    def _parse(self, row: str) -> DataRow:
        output = {}
        for k, v in self.fields.items():
            if (
                v[1] is None or len(row) >= v[1] or self.allow_missing_cols
            ):  # avoid values shorter than declared width unless specified
                val = row[v[0] : v[1] if v[1] is not None else len(row)]
                output[k] = val if len(val) else None
            else:
                incomplete_val = row[v[0] : len(row)]
                raise ValueError(f"Valore incompleto per '{k}' : {incomplete_val}")

        return output

    def _parsable(self, row: str) -> bool:
        """Da usare per filtrare la linea prima del parsing."""
        if self.accept_line_re and not self.reject_line_re:
            for reg in self.accept_line_re:
                match = re.findall(reg, row)
                if match:
                    return True

            return False

        if not self.accept_line_re and self.reject_line_re:
            for reg in self.reject_line_re:
                match = re.findall(reg, row)
                if match:
                    return False

            return True

        if self.accept_line_re and self.reject_line_re:
            raise NotImplementedError("Non è possibile inserire sia un criterio di accettazione che di rifiuto.")

        return True