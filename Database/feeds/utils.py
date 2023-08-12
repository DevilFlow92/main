import re
from datetime import date, datetime, time


def _file_date(source_path: str) -> date:
    rx = r".*(?P<date>\/\d{4}\/\d{2}\/\d{2}\/).*@\d{4}-\d{2}.\d{2}T\d{2}-\d{2}-\d{2}\+\d{2}-\d{2}"
    m = re.match(rx, source_path, re.X | re.M)
    if m:
        gd = m.groupdict()
        _date = gd.get("date")
        if _date:
            return datetime.strptime(_date, "/%Y/%m/%d/").date()
    raise ValueError(  # pragma: no cover
        f"'{source_path}' non è un path nel formato giusto. Arriva da un PullStream? Deve onorare la regex : {rx}"
    )


def _file_time(source_path: str, rx: str) -> time:
    _rx = r".*(?P<date>\/\d{4}\/\d{2}\/\d{2}\/)" + rx + r"@\d{4}-\d{2}.\d{2}T\d{2}-\d{2}-\d{2}\+\d{2}-\d{2}"
    m = re.match(_rx, source_path, re.X | re.M)
    if m:
        gd = m.groupdict()
        _hour = gd.get("hour")
        _minute = gd.get("minute")
        if _hour and _minute:
            return time(int(_hour), int(_minute))
    raise ValueError(  # pragma: no cover
        f"'{source_path}' non è un path nel formato giusto. Arriva da un PullStream? Deve onorare la regex : {rx}"
    )
