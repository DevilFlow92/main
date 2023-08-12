import time
from types import TracebackType
from typing import ContextManager, Optional, Type, Union

import eliot

from .core import LogLevel, Tags, TagValue, _get_caller_info

TaskId = bytes


def start_action(action_type: str, **tags: TagValue) -> eliot.Action:
    filename, lineno = _get_caller_info()
    return eliot.start_action(action_type=action_type, __filename=filename, __lineno=lineno, **tags)


def message(message: str, level: LogLevel = LogLevel.INFO, **tags: TagValue) -> None:
    filename, lineno = _get_caller_info()
    eliot.log_message(
        message_type="message",
        message=message,
        __filename=filename,
        __lineno=lineno,
        level=level.name,
        levelno=level.value,
        **tags
    )


def inner_message(message: str, level: LogLevel = LogLevel.INFO, **tags: TagValue) -> None:
    filename, lineno = _get_caller_info(stack_level_up=3)
    eliot.log_message(
        message_type="message",
        message=message,
        __filename=filename,
        __lineno=lineno,
        level=level.name,
        levelno=level.value,
        **tags
    )


def info(message: str, **tags: TagValue) -> None:
    inner_message(message=message, level=LogLevel.INFO, **tags)


def debug(message: str, **tags: TagValue) -> None:
    inner_message(message=message, level=LogLevel.DEBUG, **tags)


def warning(message: str, **tags: TagValue) -> None:
    inner_message(message=message, level=LogLevel.WARNING, **tags)


def error(message: str, **tags: TagValue) -> None:
    inner_message(message=message, level=LogLevel.ERROR, **tags)


def critical(message: str, **tags: TagValue) -> None:
    inner_message(message=message, level=LogLevel.CRITICAL, **tags)


def counter(metric: str, value: int, unit: str, **tags: TagValue) -> None:
    filename, lineno = _get_caller_info()
    eliot.log_message(
        message_type="counter", metric=metric, value=value, unit=unit, __filename=filename, __lineno=lineno, **tags
    )


def gauge(metric: str, value: Union[int, float], unit: str, **tags: TagValue) -> None:
    filename, lineno = _get_caller_info()
    eliot.log_message(
        message_type="gauge", metric=metric, value=value, unit=unit, __filename=filename, __lineno=lineno, **tags
    )


def timing(metric: str, value: Union[int, float], unit: str, _from_context: bool = False, **tags: TagValue) -> None:
    filename, lineno = _get_caller_info(stack_level_up=3 if _from_context else 2)
    eliot.log_message(
        message_type="timing", metric=metric, value=value, unit=unit, __filename=filename, __lineno=lineno, **tags
    )


class _TimedContextManagerDecorator(ContextManager[None]):
    def __init__(self, metric: str, tags: Tags) -> None:
        self.metric = metric
        self.tags = tags

    def __enter__(self) -> None:
        self.start_time = time.perf_counter()

    def __exit__(
        self,
        exc_type: Optional[Type[BaseException]],
        value: Optional[BaseException],
        traceback: Optional[TracebackType],
    ) -> None:
        elapsed = time.perf_counter() - self.start_time
        elapsed_ms = int(round(1000 * elapsed))
        timing(self.metric, elapsed_ms, "ms", True, **self.tags)


def timed(metric: str, **tags: TagValue) -> _TimedContextManagerDecorator:
    return _TimedContextManagerDecorator(metric, tags)
