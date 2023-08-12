import sys
from datetime import date, datetime
from decimal import Decimal
from functools import partial
from typing import Callable, Optional, Union, cast

from schema import SchemaError, Use

from .validate import is_email

Data = Union[str, bool, int, float, Decimal, date, datetime]


class Coerce(Use):
    def __init__(
        self,
        callable_: Callable[[Data], Union[None, Data]] | type,
        error: Union[None, Data] = None,
        nones: list[str] = [],
    ):
        self.nones = nones
        super().__init__(callable_, error)

    def validate(self, data: Data) -> Union[None, Data]:
        if data is None:
            return None
        if str(data).strip() in self.nones:
            return None

        return cast(Data, super().validate(data))


def to_float(separator: str = ".", thousands_separator: Optional[str] = None) -> Callable[[Data], float]:
    def _validate(data: Data) -> float:
        if isinstance(data, float):
            return data

        for _t in (int, Decimal):
            if isinstance(data, _t):
                return float(data)  # type: ignore

        if isinstance(data, str):
            if thousands_separator:
                data = data.replace(thousands_separator, "")
            return float(data.strip().replace(separator, "."))

        raise ValueError(f"Impossibile convertire il tipo {type(data)} in un Decimal")

    return _validate


def to_int(stripping_decimals: bool = False) -> Callable[[Data], int]:
    def _validate(data: Data) -> int:
        if isinstance(data, int):
            return data

        for _t in (float, Decimal, str):
            if isinstance(data, _t):
                if stripping_decimals is False:
                    if _t != str:
                        if data == int(data):  # type: ignore
                            return int(data)  # type: ignore
                    else:
                        return int(data)  # type: ignore
                else:
                    return int(float(data))  # type: ignore

        raise ValueError(f"Impossibile convertire il tipo {type(data)} in un int")

    return _validate


def to_date(templates: list[str]) -> Callable[[Data], date]:
    def _validate(data: Data) -> date:
        if isinstance(data, date):
            return data
        if len(templates) == 0:
            raise ValueError("Devi specificare almeno una stringa di template")
        for template in templates:
            try:
                output = datetime.strptime(str(data).strip(), template)
                return output.date()
            except ValueError as err:
                _raise = err
        raise _raise

    return _validate


def to_datetime(templates: list[str]) -> Callable[[Data], date]:
    def _validate(data: Data) -> date:
        if isinstance(data, datetime):
            return data
        for template in templates:
            try:
                output = datetime.strptime(str(data).strip(), template)
                return output
            except ValueError as err:
                _raise = err
        raise _raise

    return _validate


def to_decimal(  # noqa
    len_i: Union[None, int] = None,
    len_d: Union[None, int] = None,
    fixed_width: bool = True,
    decimal_separator: str = ".",
    thousands_separator: Optional[str] = None,
) -> Callable[[Data], Decimal]:
    def _validate(data: Data) -> Decimal:
        for _t in (bool, date, datetime):
            if isinstance(data, _t):
                raise ValueError(f"Impossibile convertire il tipo {type(data)} in un Decimal")

        if fixed_width:
            if len_i is None or len_d is None:
                raise ValueError("Se fixed_width devi specificare le lunghezze di parte intera e decimale")
            if isinstance(data, str):
                if len(data) != len_i + len_d:
                    raise SchemaError(f"Lunghezza {data} > lunghezza {len_i} + {len_d}")

            return Decimal(f"{data[0:len_i]}.{data[-len_d:]}")  # type: ignore

        else:
            if len_i or len_d:
                raise ValueError("Non ha senso dichiarare le lunghezze volute se l'ingresso non è fixed width")
            for _t in (Decimal, int, float):
                if isinstance(data, _t):
                    return Decimal(str(data))

            if isinstance(data, str):
                if thousands_separator:
                    data = data.replace(thousands_separator, "")
                return Decimal(data.replace(decimal_separator, "."))

        raise ValueError(f"Impossibile convertire il tipo {type(data)} in un Decimal")

    return _validate


def _validate_stripped_string(_min: int, _max: int, auto_cut: bool, data: Data) -> str:
    data_ = str(data).strip()

    if auto_cut and len(data_) > _max:
        data_ = data_[0:_max]
    if _min <= len(data_) <= _max:
        return data_
    raise SchemaError("Lunghezza della stringa non compresa nei limiti.")


def to_stripped_string(_min: int = 0, _max: int = sys.maxsize, auto_cut: bool = False) -> Callable[[Data], str]:
    return partial(_validate_stripped_string, _min, _max, auto_cut)


def to_email() -> Callable[[Data], str]:
    def _validate(data: Data) -> str:
        if isinstance(data, str):
            stripped_data = data.strip()
            try:
                is_email(stripped_data)
            except SchemaError as exc:
                raise SchemaError(f"Invalid email pattern {stripped_data}") from exc
            return stripped_data
        raise ValueError(f"Impossibile convertire il tipo {type(data)} in una email")

    return _validate


def to_bool(true_values: list[Data], false_values: Union[None, list[Data]] = None) -> Callable[[Data], bool]:
    def _validate(data: Data) -> bool:
        if data in true_values:
            return True
        if false_values is not None and data not in false_values:
            return True
        return False

    return _validate
