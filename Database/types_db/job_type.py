from enum import Enum
from typing import Any, NamedTuple, TypedDict

# Data Types Definitions
# ( we can't use named tuples due to prefect implementation details )
DataRow = dict[str, Any]


class ErrorRow(TypedDict):
    error: str
    source: DataRow


class TaskData(TypedDict):
    data: list[DataRow]
    errors: list[ErrorRow]
    meta: dict[str, Any]


class DataMatrix(TypedDict):
    data: dict[str, DataRow]  # all data rows have same schema
    errors: list[ErrorRow]
    meta: dict[str, Any]


class DataDict(TypedDict):
    data: dict[str, DataRow]  # data rows can have different schema
    errors: list[ErrorRow]
    meta: dict[str, Any]


class MessageState(Enum):
    Unprocessed = "UNP"
    Processed = "PRC"
    Cancelled = "CNC"
    GaveError = "ERR"
    Silenced = "SLN"


class DBAction(Enum):
    Insert = "INS"
    Update = "UPD"
    Delete = "DEL"


class DBObject(NamedTuple):
    table: str
    idcol: str
    id: int
    action: DBAction = DBAction.Insert


AdditionalParams = dict[str, int | str | None]


ExtParams = dict[str, int | str | None]
