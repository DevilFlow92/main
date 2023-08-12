import json
import logging as python_logging
import os
import time
from contextlib import redirect_stdout
from io import IOBase
from typing import BinaryIO, Callable, Dict, Optional, SupportsFloat, Type, Union, cast

from eliot import _bytesjson as bytesjson
from eliot import add_destinations, add_global_fields
from eliot import json as eljson
from eliot import stdlib
from pyrsistent import PClass, field

from . import core
from .core import LogLevel, Tags

__all__ = ["Tags", "LogLevel"]

_logger = python_logging.getLogger()

t_map_type = dict[str, Union[str, None]]

TRANSLATION: t_map_type = {
    "service": "applicazione",
    "namespace": "mol_formato",
    "__filename": "log.origin.file.name",
    "__lineno": "log.origin.file.line",
    "task_uuid": "event.id",
    "task_level": "event.task_level",
    "message_type": "tags",
    "message": "messaggio",
    "log_level": "log.level",
    "level": "log.level",
    "levelno": "log.level_number",
    "metric": "event.metric_name",
    "value": "event.metric_value",
    "unit": "event.metric_unit",
    "env": "mol_ambiente",
    "tenancy": "mol_sistema",
}

TRANSLATION_AIML: t_map_type = {
    "service": "project",
    "namespace": "mol_formato",
    "__filename": "module",
    "message": "logmessage",
    "log_level": "loglevel",
    "level": "loglevel",
    "env": "mol_ambiente",
    "tenancy": "mol_sistema",
}

TRANSLATION_MAPS: dict[str, t_map_type] = {"default": TRANSLATION, "mol-aiml-applicationlog": TRANSLATION_AIML}
TRANSLATION_CONFS: dict[str, dict[str, bool]] = {
    "default": {"_inclusive_filter": False},
    "mol-aiml-applicationlog": {"_inclusive_filter": True},
}

_dest_set = False
Message = Dict[str, Union[str, SupportsFloat, None]]


def _translate(message: Message) -> Message:
    translated_message: Message = {}

    translation = TRANSLATION_MAPS.get(str(message["namespace"]), TRANSLATION_MAPS["default"])
    translation_conf = TRANSLATION_CONFS.get(str(message["namespace"]), TRANSLATION_CONFS["default"])
    _inclusive_filter = translation_conf.get("_inclusive_filter", False)

    for k, v in message.items():
        if k not in translation:
            if k == "timestamp":
                translated_message["timestamp"] = time.strftime(
                    "%Y-%m-%dT%H:%M:%SZ", time.gmtime(cast(float, message["timestamp"]))
                )
            elif _inclusive_filter is False:
                translated_message[k] = v
        elif (new_key := translation[k]) is not None:
            translated_message[new_key] = v

    if "action_type" in translated_message:
        translated_message["tags"] = "action"

    if translated_message.get("tags") == "eliot:stdlib":
        translated_message["tags"] = "message"

    return translated_message


class TranslatingFileDestination(PClass):
    file: BinaryIO = field(mandatory=True)
    encoder: Type[eljson.EliotJSONEncoder] = field(mandatory=True)
    max_kbytes: int = field(mandatory=True)
    backups: int = field(mandatory=True)
    _dumps: Callable[..., str] = field(mandatory=True)
    _linebreak: str = field(mandatory=True)

    def __new__(
        cls: Type["TranslatingFileDestination"],
        file: BinaryIO,
        max_kbytes: int,
        backups: int,
        encoder: Type[eljson.EliotJSONEncoder] = eljson.EliotJSONEncoder,
    ) -> "TranslatingFileDestination":
        if isinstance(file, IOBase) and not file.writable():
            raise RuntimeError("Given file {} is not writeable.")

        unicodeFile = False
        try:
            file.write(b"")
        except TypeError:
            unicodeFile = True

        if unicodeFile:
            # On Python 3 native json module outputs unicode:
            _dumps = json.dumps
            _linebreak = "\n"
        else:
            _dumps = bytesjson.dumps
            _linebreak = b"\n"  # type: ignore
        return cast(
            TranslatingFileDestination,
            PClass.__new__(
                cls,
                file=file,
                _dumps=_dumps,
                _linebreak=_linebreak,
                encoder=encoder,
                max_kbytes=max_kbytes,
                backups=backups,
            ),
        )

    def __call__(self, message: Message) -> None:
        translated_message = _translate(message)

        if self.shouldRollover(translated_message):
            self.doRollover()

        self.file.write(self._dumps(translated_message, cls=self.encoder) + self._linebreak)  # type: ignore
        self.file.flush()

    def doRollover(self) -> None:
        self.file.seek(0)

        if self.backups > 0:
            for i in range(self.backups - 1, 0, -1):
                sfn = "%s.%d" % (self.file.name, i)
                dfn = "%s.%d" % (self.file.name, i + 1)
                if os.path.exists(sfn):
                    if os.path.exists(dfn):
                        os.remove(dfn)
                    os.rename(sfn, dfn)

            dfn = self.file.name + ".1"
            if os.path.exists(dfn):
                os.remove(dfn)
            if os.path.exists(self.file.name):
                f = open(dfn, "wb")
                f.write(self.file.read())
                f.close()

        self.file.truncate(0)

    def shouldRollover(self, message: Message) -> bool:
        if self.max_kbytes > 0:
            # self.file.seek(0, 2)  # due to non-posix-compliant Windows feature
            if self.file.tell() + len(message) >= self.max_kbytes * 1024:
                return True
        return False


class StdoutDestination:
    def __init__(self, in_docker: bool = False):
        self.in_docker = in_docker

    def __call__(self, message: Message) -> None:
        translated_message = _translate(message)
        if self.in_docker:
            with open("/proc/1/fd/1", "w") as f:
                with redirect_stdout(f):
                    print(json.dumps(translated_message))  # noqa
        else:
            print(translated_message)  # noqa


def init(
    service: str,
    logfile: Optional[str] = None,
    global_tags: Optional[core.Tags] = None,
    namespace: Optional[str] = "pycclog",
    max_kbytes: int = 0,
    backups: int = 1,
) -> None:
    global _dest_set
    core.SERVICE = service
    core.NAMESPACE_PREFIX = namespace

    if global_tags is not None:  # pragma: nocover
        core.GLOBAL_TAGS = global_tags

    add_global_fields(service=core.SERVICE, namespace=f"mol-{core.NAMESPACE_PREFIX}", **core.GLOBAL_TAGS)
    if not _dest_set:
        if logfile:
            add_destinations(TranslatingFileDestination(open(logfile, "a+b"), max_kbytes, backups))
        elif os.getenv("DEPLOY_ENV") == "loc" and logfile is not None:
            add_destinations(TranslatingFileDestination(open("/tmp/local.logs", "a+b"), max_kbytes, backups))
        else:
            add_destinations(StdoutDestination(in_docker=os.path.exists("/.dockerenv")))
        _dest_set = True

    handler = stdlib.EliotHandler()
    if type(handler) not in [type(hnd) for hnd in _logger.handlers]:
        _logger.addHandler(handler)
        _logger.setLevel(python_logging.INFO)
