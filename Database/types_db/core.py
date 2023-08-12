from datetime import date, time
from enum import Enum
from typing import Union

from pydantic import BaseModel, root_validator

Json = dict[str, "Json"] | list["Json"] | str | int | float | bool | None
JsonRes = dict[
    str,
    Union[
        "Json",
        str,
        int,
        float,
        bool,
        None,
    ],
]


class WeekDay(Enum):
    MONDAY = 0
    TUESDAY = 1
    WEDNESDAY = 2
    THURSDAY = 3
    FRIDAY = 4
    SATURDAY = 5
    SUNDAY = 6


class DateInterval(BaseModel):
    start_date: date
    end_date: date

    @root_validator
    def if_start_after_end(cls: BaseModel, v: dict[str, date]) -> dict[str, date]:
        if v["start_date"] >= v["end_date"]:
            raise ValueError("start_date must be posterior to end_date")
        return v

    class Config:
        """Convert datetime.date to isoformat."""

        json_encoders = {date: lambda v: v.isoformat()}


class TimeInterval(BaseModel):
    start_time: time  # 20.00
    end_time: time  # 08:35

    class Config:
        """Convert datetime.time to isoformat."""

        json_encoders = {time: lambda v: v.isoformat()}
