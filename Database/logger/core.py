import enum
import inspect
import os
from typing import Dict, Optional, Tuple, Union

TagValue = Union[str, int, float]
Tags = Dict[str, TagValue]

VERBOSE_ENVS = {
    "loc": "loc",
    "none": "none",
    "tst": "test",
    "dts": "dmztest",
    "dpd": "dmzprod",
    "stg": "staging",
    "prd": "produzione",
    "aip": "produzione",
}

SERVICE: str = ""
DEPLOY_ENV = os.getenv("DEPLOY_ENV", "none")
GLOBAL_TAGS: Tags = {"env": VERBOSE_ENVS.get(DEPLOY_ENV, "none"), "tenancy": os.getenv("TENANCY", "none")}
NAMESPACE_PREFIX: Optional[str] = None


class LogLevel(enum.Enum):
    CRITICAL = 50
    ERROR = 40
    WARNING = 30
    INFO = 20
    DEBUG = 10


def _get_caller_info(stack_level_up: int = 2) -> Tuple[str, int]:
    caller = inspect.getframeinfo(inspect.stack()[stack_level_up][0])
    return caller.filename, caller.lineno
