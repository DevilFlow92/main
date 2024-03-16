import enum
import ftplib
import functools
import os
import posixpath
import shutil
import socket
import tempfile
from abc import ABC, abstractmethod
from datetime import datetime, timezone
from pathlib import Path, PosixPath
from posix import stat_result
from types import TracebackType
from typing import Any, BinaryIO, Callable, ContextManager, MutableMapping, NamedTuple, Optional, Type, TypeVar, cast

import boto3
import ftputil
import paramiko
from minio import Minio
from paramiko.rsakey import RSAKey
from smb.smb_structs import OperationFailure
from smb.SMBConnection import SMBConnection
from ssh2 import exceptions as ssh2_exceptions
from ssh2 import session as ssh2_session
from ssh2 import sftp as ssh2_sftp
from webdav3.client import Client

import logger
from logger import log
from types_db.core import JsonRes


class _Type(enum.Enum):
    FILE = "file"
    DIR = "dir"


class FileMetadata(NamedTuple):
    type_: _Type
    size: int
    modify: datetime
    key: str


RemoteFtpFiles = MutableMapping[str, FileMetadata]


_FuncT = TypeVar("_FuncT", bound=Callable[..., Any])


class ABCFtp(ContextManager["ABCFtp"], ABC):
    """Base class from which to implement operations on resources serving remote files.

    Resource auth credentials and config parameters must be defined in a vault entry with this schema:

    "host": IP of DNS address
    "port": can be empty to use the default
    "username":
    "password":
    "path": paths used as argument in methods will be relative to this (leading / are stripped from arguments)
    "protocol": {"ftp", "sftp", "webdav", "s3"}
    """

    def __init__(self, *args: Any, **kwargs: Any) -> None:
        if "path" not in kwargs:
            raise ValueError("Manca il path nella configurazione sul vault.")
        if not kwargs["path"].startswith("/"):
            raise ValueError("Il path configurato nel vault non è assoluto.")
        for k in kwargs:
            setattr(self, k, kwargs[k])
        self.path = PosixPath(kwargs["path"])
        if "port" in kwargs:
            self.port = int(kwargs["port"])

    def __enter__(self) -> "ABCFtp":
        self.open_connection()
        return self

    def __exit__(
        self,
        exc_type: Optional[Type[BaseException]],
        value: Optional[BaseException],
        traceback: Optional[TracebackType],
    ) -> None:
        try:
            self.close_connection()
        except Exception as exc:
            log.message(message=f"Fileshare connection close failed, reason '{str(exc)}'", level=logger.LogLevel.ERROR)

    def _full_path(self, path: PosixPath) -> PosixPath:
        if str(path).startswith("/"):
            raise ValueError(
                f"'{path}' deve essere relativo alla radice configurata nel vault :\n"
                f"Usa '{str(path).lstrip('/')}' per raggiungere "
                f"'{(getattr(self, 'path') / str(path).lstrip('/')).as_posix()}'"
            )
        return self.path / PosixPath(str(path))

    @abstractmethod
    def open_connection(self) -> None:
        raise NotImplementedError()

    @abstractmethod
    def close_connection(self) -> None:
        raise NotImplementedError()

    @abstractmethod
    def describe(self, path: PosixPath) -> RemoteFtpFiles:
        """Return FileMetadata for path (for all contained files if path is a directory)."""
        raise NotImplementedError()

    @abstractmethod
    def create_directory(self, path: PosixPath, mode: int = 777) -> None:
        raise NotImplementedError()

    @abstractmethod
    def delete_directory(self, path: PosixPath) -> None:
        raise NotImplementedError()

    @abstractmethod
    def retrieve(self, remote_path: PosixPath, local_path: PosixPath) -> PosixPath:
        raise NotImplementedError()

    @abstractmethod
    def store(self, local_path: PosixPath, remote_path: PosixPath) -> PosixPath:
        raise NotImplementedError()

    @abstractmethod
    def store_data(self, data: BinaryIO, remote_path: PosixPath) -> PosixPath:
        raise NotImplementedError()

    @abstractmethod
    def delete(self, path: PosixPath) -> None:
        raise NotImplementedError()

def _os_stat(path: str) -> stat_result:
    return os.stat(path)

def _from_scheme(scheme: str) -> Type[ABCFtp]:
    if scheme == "ftp":
        return FTP

    if scheme == "dumbftp":
        return DumbFTP

    if scheme == "sftp":
        return SFTP

    if scheme == "ksftp":
        return KSFTP

    if scheme == "psftp":
        return PSFTP

    if scheme == "pksftp":
        return ParamikoKeySFTP

    if scheme == "webdav":
        return WebDAV

    if scheme == "s3":
        return S3

    if scheme == "minio":
        return MinIO

    if scheme == "cifs":
        return CIFS

    if scheme == "fakeftp":
        return FakeFTP

    raise Exception(f"unsupported FTP type {scheme}")


def ftp_conn(auth: JsonRes) -> ABCFtp:
    return _from_scheme(str(auth["protocol"]))(**auth)


def maybe_reconnect(fun: _FuncT) -> _FuncT:
    @functools.wraps(fun)
    def wrapped_fun(self: Any, *args: Any, **kwargs: Any) -> Any:
        try:
            return fun(self, *args, **kwargs)
        except Exception as exc:
            if any(isinstance(exc, c) for c in ftplib.all_errors):
                log.message("FTP connection closed, trying to reconnect", level=logger.LogLevel.ERROR)
                self.open_connection()
                return fun(self, *args, **kwargs)
            else:
                raise

    return cast(_FuncT, wrapped_fun)


class CIFS(ABCFtp):
    def open_connection(self) -> None:
        port = self.port if getattr(self, "port", None) is not None else 139
        self.conn = SMBConnection(
            username=getattr(self, "username"),
            password=getattr(self, "password"),
            my_name="pycc_code",
            remote_name=getattr(self, "host"),
            is_direct_tcp=port == 445,
        )
        self.conn.connect(getattr(self, "host"), port)

    def close_connection(self) -> None:
        self.conn.close()

    def describe(self, path: PosixPath) -> RemoteFtpFiles:
        files = {}
        path_ = self._full_path(path)
        try:
            FD = self.conn.getAttributes(getattr(self, "share"), str(path_))
            if FD.isDirectory:
                for file in self.conn.listPath(getattr(self, "share"), str(path_)):
                    if file.filename not in (".", ".."):
                        files[file.filename] = FileMetadata(
                            type_=_Type.DIR if file.isDirectory else _Type.FILE,
                            size=file.file_size,
                            modify=datetime.fromtimestamp(file.last_write_time, timezone.utc).replace(microsecond=0),
                            key=(path / file.filename).as_posix(),
                        )

            else:
                files[FD.filename] = FileMetadata(
                    type_=_Type.FILE,
                    size=FD.file_size,
                    modify=datetime.fromtimestamp(FD.last_write_time, timezone.utc).replace(microsecond=0),
                    key=path.as_posix(),
                )

        except OperationFailure:  # In our logic unexisting directory is just "no files"
            pass

        return files

    def create_directory(self, path: PosixPath, mode: int = 777) -> None:
        raise NotImplementedError()

    def delete_directory(self, path: PosixPath) -> None:
        raise NotImplementedError()

    def retrieve(self, remote_path: PosixPath, local_path: PosixPath) -> PosixPath:
        remote_path_ = self._full_path(remote_path)
        file_path = local_path / remote_path.name if local_path.is_dir() else local_path
        with open(file_path, "wb") as f:
            self.conn.retrieveFile(getattr(self, "share"), str(remote_path_), f)

        return file_path

    def store(self, local_path: PosixPath, remote_path: PosixPath) -> PosixPath:
        prefix = str(self.path)
        remote_path_ = self._full_path(remote_path)
        for part in remote_path.parts:
            if part != remote_path.name:
                prefix = (prefix + "/" + part).lstrip().replace("//", "/")
                try:
                    self.conn.createDirectory(getattr(self, "share"), prefix)
                except OperationFailure:
                    pass  # existing directory gives exception

        with open(local_path, "rb") as f:
            self.conn.storeFile(getattr(self, "share"), str(remote_path_), f)

        return remote_path

    def delete(self, path: PosixPath) -> None:
        path_ = self._full_path(path)
        self.conn.deleteFiles(getattr(self, "share"), str(path_))

    def store_data(self, data: BinaryIO, remote_path: PosixPath) -> PosixPath:
        raise NotImplementedError()


class S3(ABCFtp):
    def open_connection(self) -> None:
        self.conn = boto3.resource(
            "s3",
            endpoint_url=f"http://{getattr(self, 'host')}:{getattr(self,'port',9000)}/",
            aws_access_key_id=getattr(self, "username"),
            aws_secret_access_key=getattr(self, "password"),
        )
        self.bucket_ = self.conn.Bucket(getattr(self, "bucket"))

    def close_connection(self) -> None:
        self.conn = None

    def describe(self, path: PosixPath) -> RemoteFtpFiles:
        output = {}
        path_ = self._full_path(path)
        s3_path = str(path_).lstrip("/")

        if s3_path.startswith(getattr(self, "bucket")):
            s3_path = s3_path[len(getattr(self, "bucket")) :]

            isdir = False
        try:
            self.conn.Object(bucket_name=self.bucket_.name, key=s3_path).content_type
        except Exception:
            isdir = True

        if isdir:
            objects = self.bucket_.objects.filter(Prefix=s3_path)
            for obj in objects:
                output[Path(obj.key).name] = FileMetadata(
                    type_=_Type.FILE,
                    size=obj.size,
                    modify=obj.last_modified.replace(microsecond=0),
                    key=(path / Path(obj.key).name).as_posix(),
                )
        else:
            obj_ = self.conn.Object(bucket_name=self.bucket_.name, key=s3_path)
            output[Path(s3_path).name] = FileMetadata(
                type_=_Type.FILE,
                size=obj_.content_length,
                modify=obj_.last_modified.replace(microsecond=0),
                key=path.as_posix(),
            )

        return output

    def create_directory(self, path: PosixPath, mode: int = 777) -> None:
        raise NotImplementedError()

    def delete_directory(self, path: PosixPath) -> None:
        raise NotImplementedError()

    def retrieve(self, remote_full_path: PosixPath, local_full_path: PosixPath) -> PosixPath:
        file_path = local_full_path / remote_full_path.name if local_full_path.is_dir() else local_full_path
        self.bucket_.download_file(str(remote_full_path).lstrip("/"), str(file_path))
        return file_path

    def store(self, local_full_path: PosixPath, remote_full_path: PosixPath) -> PosixPath:
        s3_path = str(remote_full_path).lstrip("/")
        if s3_path.startswith(getattr(self, "bucket")):
            s3_path = s3_path[len(getattr(self, "bucket")) :]
        self.bucket_.upload_file(str(local_full_path), s3_path)
        return PosixPath(s3_path)

    def delete(self, path: PosixPath) -> None:
        self.bucket_.delete_objects(
            Delete={
                "Objects": [
                    {"Key": path},
                ],
            },
        )

    def store_data(self, data: BinaryIO, remote_path: PosixPath) -> PosixPath:
        raise NotImplementedError()


class MinIO(ABCFtp):
    def open_connection(self) -> None:
        if os.environ.get("SSL_CERT_FILE") is None:
            raise RuntimeError("SSL_CERT_FILE env var needs to be set")
        self.client = Minio(
            f"{getattr(self, 'host')}:{getattr(self, 'port', 9000)}",
            access_key=getattr(self, "username"),
            secret_key=getattr(self, "password"),
        )

    def close_connection(self) -> None:
        pass

    def describe(self, path: PosixPath) -> RemoteFtpFiles:
        output = {}
        path_ = self._full_path(path)
        s3_path = str(path_).lstrip("/")

        is_dir = False
        try:
            self.client.get_object(bucket_name=getattr(self, "bucket"), object_name=s3_path)
        except Exception:
            is_dir = True

        if is_dir:
            objects = self.client.list_objects(getattr(self, "bucket"), prefix=s3_path, recursive=True)
            for obj in objects:
                output[Path(obj.object_name).name] = FileMetadata(
                    type_=_Type.DIR if obj.is_dir else _Type.FILE,
                    size=obj.size,
                    modify=obj.last_modified.replace(microsecond=0),
                    key=(Path(path) / Path(obj.object_name).name).as_posix(),
                )
        else:
            obj_ = self.client.get_object(bucket_name=getattr(self, "bucket"), object_name=s3_path)
            date = datetime.strptime(obj_.getheaders()["last-modified"], "%a, %d %b %Y %H:%M:%S %Z")
            output[Path(s3_path).name] = FileMetadata(
                type_=_Type.FILE,
                size=obj_.getheaders()["content-length"],
                modify=date.replace(tzinfo=timezone.utc),
                key=path.as_posix(),
            )

        return output

    def create_directory(self, path: PosixPath, mode: int = 777) -> None:
        raise NotImplementedError()

    def delete_directory(self, path: PosixPath) -> None:
        raise NotImplementedError()

    def retrieve(self, remote_path: PosixPath, local_full_path: PosixPath) -> PosixPath:
        remote_full_path = self._full_path(remote_path)
        file_path = local_full_path / remote_full_path.name if local_full_path.is_dir() else local_full_path
        self.client.fget_object(getattr(self, "bucket"), remote_full_path.as_posix(), file_path.as_posix())
        return file_path

    def store(self, local_path: PosixPath, remote_path: PosixPath) -> PosixPath:
        remote_path_ = self._full_path(remote_path)
        self.client.fput_object(getattr(self, "bucket"), remote_path_.as_posix().lstrip("/"), local_path.as_posix())
        return remote_path

    def delete(self, path: PosixPath) -> None:
        remote_path = self._full_path(path)
        self.client.remove_object(getattr(self, "bucket"), remote_path.as_posix().lstrip("/"))

    def store_data(self, data: BinaryIO, remote_path: PosixPath) -> PosixPath:
        remote_path_ = self._full_path(remote_path)
        self.client.put_object(
            getattr(self, "bucket"),
            remote_path_.as_posix().lstrip("/"),
            data,
            length=-1,
            part_size=10 * 1024 * 1024,
        )
        return remote_path


class DumbFTP(ABCFtp):
    def open_connection(self) -> None:
        self.conn = ftputil.FTPHost(getattr(self, "host"), getattr(self, "username"), getattr(self, "password"))

    def close_connection(self) -> None:
        self.conn.close()

    @maybe_reconnect
    def describe(self, path: PosixPath) -> RemoteFtpFiles:
        path_ = self._full_path(path)

        if self.conn.path.isfile(path_):
            facts = self.conn.lstat(path_)
            return {
                Path(path_).name: FileMetadata(
                    type_=_Type.FILE,
                    size=facts.st_size,
                    modify=datetime.fromtimestamp(facts.st_mtime),
                    key=path.as_posix(),
                )
            }

        output = {}
        for name in self.conn.listdir(path_):
            full_path = str((path_ / str(name)))
            facts = self.conn.lstat(full_path)
            output[name] = FileMetadata(
                type_=_Type.FILE if self.conn.path.isfile(full_path) else _Type.DIR,
                size=facts.st_size,
                modify=datetime.fromtimestamp(facts.st_mtime),
                key=(path / str(name)).as_posix(),
            )

        return output

    @maybe_reconnect
    def create_directory(self, path: PosixPath, mode: int = 777) -> None:
        raise NotImplementedError()

    @maybe_reconnect
    def delete_directory(self, path: PosixPath) -> None:
        pass

    @maybe_reconnect
    def retrieve(self, remote_full_path: PosixPath, local_full_path: PosixPath) -> PosixPath:
        self.conn.download(remote_full_path, local_full_path)  # remote, local
        return local_full_path

    @maybe_reconnect
    def store(self, local_full_path: PosixPath, remote_name: PosixPath) -> PosixPath:
        remote_full_path = self._full_path(remote_name)
        remote_path, _ = posixpath.split(remote_full_path)
        self.conn.makedirs(remote_path, exist_ok=True)
        self.conn.upload(local_full_path, remote_full_path)

        return remote_full_path

    @maybe_reconnect
    def delete(self, path: PosixPath) -> None:
        absolute_path = posixpath.join(self.path, str(path).lstrip("/"))
        self.conn.remove(absolute_path)

    def store_data(self, data: BinaryIO, remote_path: PosixPath) -> PosixPath:
        raise NotImplementedError()


class FTP(ABCFtp):
    def open_connection(self) -> None:  # noqa
        self.conn = ftplib.FTP()
        self.conn.connect(getattr(self, "host"), self.port)
        self.conn.login(getattr(self, "username"), getattr(self, "password"))

    def close_connection(self) -> None:
        self.conn.quit()

    @maybe_reconnect
    def describe(self, path: PosixPath) -> RemoteFtpFiles:
        path_ = self._full_path(path)

        output: dict[str, FileMetadata] = {}
        if self.conn.voidcmd(f"STAT {path_}").split("\n")[1][0] == "d":
            for name, facts in self.conn.mlsd(facts=("type", "size", "modify")):
                if facts["type"] != "cdir":  # skip '.' and '..'
                    type_ = _Type.FILE if facts["type"] == "file" else _Type.DIR
                    output[name] = FileMetadata(
                        type_=type_,
                        size=int(facts["size"]) if type_ == _Type.FILE else 0,
                        modify=self._datetime(facts["modify"]),
                        key=(path / name).as_posix(),
                    )

        if self.conn.voidcmd(f"STAT {path_}").split("\n")[1][0] == "-":
            filename = os.path.basename(path_)
            output[filename] = FileMetadata(
                type_=_Type.FILE,
                modify=datetime.strptime(self.conn.voidcmd(f"MDTM {path_}")[4:].strip(), "%Y%m%d"),
                size=self.conn.size(path_),  # type: ignore
                key=path.as_posix(),
            )

        return output

    @maybe_reconnect
    def create_directory(self, path: PosixPath, mode: int = 777) -> None:
        raise NotImplementedError()

    @maybe_reconnect
    def delete_directory(self, path: PosixPath) -> None:
        raise NotImplementedError()

    @maybe_reconnect
    def retrieve(self, remote_full_path: PosixPath, local_full_path: PosixPath) -> PosixPath:
        remote_path, remote_file_name = posixpath.split(remote_full_path)
        self.conn.cwd(remote_path)

        with open(local_full_path, "wb") as f:
            self.conn.retrbinary(f"RETR {remote_file_name}", f.write)

        return local_full_path

    @maybe_reconnect
    def store(self, local_full_path: PosixPath, remote_full_path: PosixPath) -> PosixPath:
        remote_path, remote_file_name = posixpath.split(remote_full_path)
        c = ""
        for d in remote_path.split("/"):
            if d:
                c = c + "/" + d
                try:
                    self.conn.mkd(c)
                except ftplib.error_perm:
                    pass
        self.conn.cwd(remote_path)

        with open(local_full_path, "rb") as f:
            self.conn.storbinary(f"STOR {remote_file_name}", f)

        return remote_full_path

    @maybe_reconnect
    def delete(self, path: PosixPath) -> None:
        absolute_path = posixpath.join(self.path, str(path).lstrip("/"))
        self.conn.delete(absolute_path)

    def _datetime(self, time_str: str) -> datetime:
        # time_str optionally has microseconds
        try:
            res = datetime.strptime(time_str, "%Y%m%d%H%M%S.%f").replace(microsecond=0)

        except ValueError:
            res = datetime.strptime(time_str, "%Y%m%d%H%M%S")

        return datetime.combine(res.date(), res.time(), timezone.utc)

    def store_data(self, data: BinaryIO, remote_path: PosixPath) -> PosixPath:
        raise NotImplementedError()


class SFTP(ABCFtp):
    def open_connection(self) -> None:
        self.session = cast(ssh2_session.Session, None)
        self.sftp = cast(ssh2_sftp.SFTP, None)
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect((getattr(self, "host"), self.port))
        self.session = ssh2_session.Session()
        self.session.handshake(sock)
        self.session.userauth_password(getattr(self, "username"), getattr(self, "password"))

        self.sftp = self.session.sftp_init()

    def close_connection(self) -> None:
        self.session.disconnect()

    def describe(self, path: PosixPath) -> RemoteFtpFiles:
        path_ = self._full_path(path)
        files = {}
        try:
            with self.sftp.opendir(str(path_)) as flist:
                for _, filename, attributes in flist.readdir():
                    if isinstance(filename, bytes):
                        filename = filename.decode("UTF-8")
                    if filename not in (".", ".."):
                        files[filename] = FileMetadata(
                            type_=_Type.DIR
                            if (attributes.permissions & ssh2_sftp.LIBSSH2_SFTP_S_IFDIR)
                            else _Type.FILE,
                            size=attributes.filesize,
                            modify=datetime.fromtimestamp(attributes.mtime, timezone.utc).replace(microsecond=0),
                            key=PosixPath(path, filename).as_posix(),
                        )
        except ssh2_exceptions.SFTPProtocolError:
            with self.sftp.open(str(path_), ssh2_sftp.LIBSSH2_FXF_READ, ssh2_sftp.LIBSSH2_SFTP_S_IRUSR) as f:
                stats = f.fstat()
                files[path.name] = FileMetadata(
                    type_=_Type.FILE,
                    size=stats.filesize,
                    modify=datetime.fromtimestamp(stats.mtime, timezone.utc).replace(microsecond=0),
                    key=path.as_posix(),
                )

        return files

    def create_directory(self, path: PosixPath, mode: int = 777) -> None:
        raise NotImplementedError()

    def delete_directory(self, path: PosixPath) -> None:
        raise NotImplementedError()

    def retrieve(self, remote_full_path: PosixPath, local_full_path: PosixPath) -> PosixPath:
        file_path = local_full_path / remote_full_path.name if local_full_path.is_dir() else local_full_path
        path_ = self.path / remote_full_path
        with tempfile.TemporaryFile() as fp:
            with self.sftp.open(
                path_.as_posix(), ssh2_sftp.LIBSSH2_FXF_READ, ssh2_sftp.LIBSSH2_SFTP_S_IRUSR
            ) as remote_fh:
                for _, data in remote_fh:
                    fp.write(data)
                    fp.flush()
            with open(file_path, "wb") as f:
                fp.seek(0)
                f.write(fp.read())
                f.flush()

        return file_path

    def store(self, local_full_path: PosixPath, remote_full_path: PosixPath) -> PosixPath:
        remote_path = self._full_path(remote_full_path)
        prefix = ""
        for part in remote_path.parts:
            if part != remote_path.name:
                prefix = prefix + "/" + part
                try:
                    self.sftp.mkdir(
                        prefix,
                        ssh2_sftp.LIBSSH2_SFTP_S_IRWXU
                        | ssh2_sftp.LIBSSH2_SFTP_S_IRWXG
                        | ssh2_sftp.LIBSSH2_SFTP_S_IRWXO,
                    )
                except ssh2_exceptions.SSH2Error:
                    pass  # existing directory gives exception

        mode = (
            ssh2_sftp.LIBSSH2_SFTP_S_IRUSR
            | ssh2_sftp.LIBSSH2_SFTP_S_IWUSR
            | ssh2_sftp.LIBSSH2_SFTP_S_IRGRP
            | ssh2_sftp.LIBSSH2_SFTP_S_IROTH
        )
        f_flags = ssh2_sftp.LIBSSH2_FXF_CREAT | ssh2_sftp.LIBSSH2_FXF_WRITE
        with open(local_full_path.as_posix(), "rb") as local_fh, self.sftp.open(
            remote_path.as_posix(), f_flags, mode
        ) as remote_fh:
            for data in local_fh:
                remote_fh.write(data)

        return remote_full_path

    def delete(self, path: PosixPath) -> None:
        path_ = self._full_path(path)
        try:
            self.sftp.unlink(str(path_))
        except Exception as ex:
            raise ValueError(f"errore cancellando il file {path_}: {ex}")

    def store_data(self, data: BinaryIO, remote_path: PosixPath) -> PosixPath:
        raise NotImplementedError()


class PSFTP(ABCFtp):
    def open_connection(self) -> None:
        self.transport = paramiko.Transport((getattr(self, "host"), getattr(self, "port", 22)))
        self.transport.connect(None, getattr(self, "username"), getattr(self, "password"))
        self.sftp: paramiko.SFTPClient = cast(paramiko.SFTPClient, paramiko.SFTPClient.from_transport(self.transport))

    def close_connection(self) -> None:
        if self.sftp:
            self.sftp.close()

    def describe(self, path: PosixPath) -> RemoteFtpFiles:
        path_ = self._full_path((path))
        files: dict[str, FileMetadata] = {}
        try:
            isdir = str(self.sftp.lstat(str(path_)))[0] == "d"
        except FileNotFoundError:
            return files

        if isdir:
            for sftpattr in self.sftp.listdir_attr(str(path_)):
                files[sftpattr.filename] = FileMetadata(
                    type_=_Type.DIR if (sftpattr.longname[0] == "d") else _Type.FILE,
                    size=sftpattr.st_size,  # type: ignore
                    modify=datetime.fromtimestamp(sftpattr.st_mtime, timezone.utc).replace(  # type: ignore
                        microsecond=0
                    ),
                    key=(path / sftpattr.filename).as_posix(),
                )
        else:
            sftpattr = self.sftp.lstat(str(path_))
            files[path.name] = FileMetadata(
                type_=_Type.FILE,
                size=sftpattr.st_size,  # type: ignore
                modify=datetime.fromtimestamp(sftpattr.st_mtime, timezone.utc).replace(microsecond=0),  # type: ignore
                key=path.as_posix(),
            )

        return files

    def create_directory(self, path: PosixPath, mode: int = 777) -> None:
        pass

    def delete_directory(self, path: PosixPath) -> None:
        raise NotImplementedError()

    def retrieve(self, remote_path: PosixPath, local_full_path: PosixPath) -> PosixPath:
        remote_full_path = self._full_path(remote_path)
        file_path = local_full_path / remote_full_path.name if local_full_path.is_dir() else local_full_path
        with tempfile.TemporaryFile() as tf:
            with self.sftp.open(remote_full_path.as_posix(), "rb") as rf:
                for data in rf:
                    tf.write(data)
                    tf.flush()

            with open(file_path, "wb") as fl:
                tf.seek(0)
                fl.write(tf.read())
                fl.flush()
        return file_path

    def store(self, local_full_path: PosixPath, remote_full_path: PosixPath) -> PosixPath:
        try:
            isdir = str(self.sftp.lstat(remote_full_path.as_posix()))[0] == "d"
            if isdir:
                remote_filepath = remote_full_path / local_full_path.name
            else:
                remote_filepath = remote_full_path
        except FileNotFoundError:
            remote_filepath = remote_full_path

        remote_path, _ = posixpath.split(remote_filepath)
        prefix = ""
        for part in remote_path.split("/"):
            if part:
                prefix = prefix + "/" + part
                try:
                    self.sftp.mkdir(prefix)
                except OSError:
                    pass  # existing directory gives exception

        self.sftp.put(local_full_path.as_posix(), remote_filepath.as_posix())
        return remote_full_path

    def delete(self, path: PosixPath) -> None:
        raise NotImplementedError()

    def store_data(self, data: BinaryIO, remote_path: PosixPath) -> PosixPath:
        raise NotImplementedError()


class ParamikoKeySFTP(PSFTP):
    def open_connection(self) -> None:
        self.transport = paramiko.Transport((getattr(self, "host"), getattr(self, "port", 22)))
        with tempfile.NamedTemporaryFile("w+") as fp:
            fp.write(getattr(self, "private_key").replace("\\n", "\n"))
            fp.seek(0)
            pk = RSAKey(file_obj=fp)
            self.transport.connect(None, username=getattr(self, "username"), pkey=pk)
            self.sftp: paramiko.SFTPClient = cast(
                paramiko.SFTPClient, paramiko.SFTPClient.from_transport(self.transport)
            )


class KSFTP(SFTP):
    r"""Collega a un sftp autenticato con chiave asimmetrica.

    La stringa corretta da salvare nel vault viene generata nel seguente modo :

    - se la chiave fornita è in formato putty esportare le due parti :

        ```
        puttygen file.ppk -O public-openssh -o public_key_file  # nel vault come "public_key"
        puttygen file.ppk -O private-openssh -o private_key_file
        ```

    - copia incollare i valori nel vault come solo testo passando dalla UI ( non json editor )
        per essere sicuri che la formattazione resti corretta.

    """

    def open_connection(self) -> None:
        self.session = cast(ssh2_session.Session, None)
        self.sftp = cast(ssh2_sftp.SFTP, None)
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect((getattr(self, "host"), self.port))

        self.session = ssh2_session.Session()
        self.session.handshake(sock)
        with tempfile.NamedTemporaryFile("w") as w:
            w.write(getattr(self, "private_key").replace("\\n", "\n"))
            w.flush()
            self.session.userauth_publickey_fromfile(
                getattr(self, "username"),
                privatekey=w.name,
            )
        self.sftp = self.session.sftp_init()

    def close_connection(self) -> None:
        self.session.disconnect()


class WebDAV(ABCFtp):
    def open_connection(self) -> None:
        options = {
            "webdav_hostname": getattr(self, "host"),
            "webdav_login": getattr(self, "username"),
            "webdav_password": getattr(self, "password"),
        }
        self.client = Client(options)

    def close_connection(self) -> None:
        pass

    def describe(self, path: PosixPath) -> RemoteFtpFiles:
        files = {}
        path_ = str(self._full_path(path))
        name = None
        try:
            infos = self.client.list(path_, get_info=True)
            for info in infos:
                name = Path(info["path"]).name
                files[name] = FileMetadata(
                    type_=_Type.DIR if info["isdir"] else _Type.FILE,
                    size=info["size"],
                    modify=datetime.strptime(info["modified"], "%a, %d %b %Y %H:%M:%S GMT"),
                    key=(path / name).as_posix(),
                )
        except Exception as ex:
            if name is None:
                raise ex
            obj = self.client.info(path_)
            files[name] = FileMetadata(
                type_=_Type.FILE,
                size=obj["size"],
                modify=datetime.strptime(obj["modified"], "%a, %d %b %Y %H:%M:%S GMT"),
                key=path.as_posix(),
            )

        return files

    def create_directory(self, path: PosixPath, mode: int = 777) -> None:
        raise NotImplementedError

    def delete_directory(self, path: PosixPath) -> None:
        raise NotImplementedError

    def retrieve(self, remote_full_path: PosixPath, local_full_path: PosixPath) -> PosixPath:
        self.client.download_sync(remote_path=remote_full_path, local_path=local_full_path)
        return local_full_path

    def store(self, local_full_path: PosixPath, remote_full_path: PosixPath) -> PosixPath:
        self.client.upload_sync(remote_path=remote_full_path, local_path=local_full_path)
        return remote_full_path

    def delete(self, path: PosixPath) -> None:
        raise NotImplementedError

    def store_data(self, data: BinaryIO, remote_path: PosixPath) -> PosixPath:
        raise NotImplementedError()


class FakeFTP(ABCFtp):
    _ftp_tmp_dir = tempfile.mkdtemp()

    @property
    def _timestamp(self) -> datetime:
        fake_ts_string = os.getenv("TEST_FAKEFTP_TIMESTAMP")
        if fake_ts_string:
            return datetime.fromisoformat(fake_ts_string)
        return self.fake_timestamp

    def open_connection(self) -> None:
        # self.args = args
        # self.kwargs = kwargs
        self.fake_timestamp = datetime.now()
        if self.path:
            self.ftp_dir = self.path
        else:
            self.ftp_dir = PosixPath(os.path.join(self._ftp_tmp_dir, getattr(self, "host")))

        if not os.path.exists(self.ftp_dir):
            os.mkdir(self.ftp_dir)
        self.connected = True

    def close_connection(self) -> None:
        self.connected = False

    def _assert_connected(self) -> None:
        if not self.connected:
            raise RuntimeError("FTP connection not open")

    def _list_directory(self, path: str) -> list[str]:
        self._assert_connected()
        path = self._ftp_subpath(PosixPath(path))
        try:
            return os.listdir(path)
        except FileNotFoundError:
            return []

    def describe(self, path: PosixPath) -> RemoteFtpFiles:
        self._assert_connected()
        path_ = str(path)

        files = {}
        if os.path.isfile(path):
            stats = _os_stat(path)  # type: ignore
            files[path] = FileMetadata(
                type_=_Type.DIR if os.path.isdir(path) else _Type.FILE,
                size=stats.st_size,
                modify=self._timestamp,
                key=PosixPath(path_.replace(str(self.ftp_dir), ""), path).as_posix(),
            )

        else:
            for f in self._list_directory(path_):
                abs_f = self._ftp_subpath(PosixPath(path) / f)
                stats = _os_stat(abs_f)
                files[f] = FileMetadata(  # type: ignore
                    type_=_Type.DIR if os.path.isdir(abs_f) else _Type.FILE,
                    size=stats.st_size,
                    modify=self._timestamp,
                    key=PosixPath(path_, f"{f.strip('/')}/").as_posix(),
                )
        return files  # type: ignore

    def create_directory(self, path: PosixPath, mode: int = 0o777) -> None:
        self._assert_connected()

        os.mkdir(self._ftp_subpath(path), mode)

    def delete_directory(self, path: PosixPath) -> None:
        self._assert_connected()

        path_ = self._ftp_subpath(path)

        if path_ == str(self.ftp_dir):
            raise RuntimeError("Cannot delete FTP root directory")

        shutil.rmtree(path_)

    def retrieve(self, remote_full_path: PosixPath, local_full_path: PosixPath) -> PosixPath:
        self._assert_connected()

        path = self._ftp_subpath(remote_full_path)
        file_path = local_full_path / remote_full_path.name if local_full_path.is_dir() else local_full_path

        shutil.copyfile(path, file_path)

        return file_path

    def store(self, local_full_path: PosixPath, remote_full_path: PosixPath) -> PosixPath:
        self._assert_connected()

        remote_path, _ = posixpath.split(remote_full_path)

        Path(self._ftp_subpath(PosixPath(remote_path))).mkdir(parents=True, exist_ok=True)

        path = self._ftp_subpath(remote_full_path)
        shutil.copyfile(local_full_path, path)

        return PosixPath(path)

    def delete(self, path: PosixPath) -> None:
        self._assert_connected()

        path_ = self._ftp_subpath(path)
        os.remove(path_)

    def reset(self) -> None:
        shutil.rmtree(self.ftp_dir)

    def _ftp_subpath(self, path: PosixPath) -> str:
        if not str(path).startswith(str(self.ftp_dir)):
            return str(os.path.join(self.ftp_dir, path))

        return str(path)

    def store_data(self, data: BinaryIO, remote_path: PosixPath) -> PosixPath:
        raise NotImplementedError()
