#!/usr/bin/env python3
import os
from pathlib import Path
import shutil
import socket
import struct
import subprocess
import sys
import tempfile
import time


def p9_string(value):
    encoded = value.encode()
    return struct.pack("<H", len(encoded)) + encoded


def stat_names(data):
    names = []
    offset = 0
    while offset < len(data):
        size = struct.unpack_from("<H", data, offset)[0]
        stat = data[offset + 2:offset + 2 + size]
        name_offset = 2 + 4 + 13 + 4 + 4 + 4 + 8
        length = struct.unpack_from("<H", stat, name_offset)[0]
        start = name_offset + 2
        names.append(stat[start:start + length].decode("latin-1"))
        offset += size + 2
    return names


class Client:

    def __init__(self, stream):
        self.stream = stream
        self.stream.settimeout(30)
        self.tag = 0

    def exact(self, size):
        result = bytearray()
        while len(result) < size:
            chunk = self.stream.recv(size - len(result))
            if not chunk:
                raise EOFError("RISC OS closed the 9P stream")
            result.extend(chunk)
        return bytes(result)

    def ready(self):
        received = bytearray()
        marker = b"9D-READY\n"
        deadline = time.monotonic() + 30
        while not received.endswith(marker):
            if time.monotonic() >= deadline:
                raise TimeoutError(
                    f"RISC OS did not announce 9d readiness; serial tail: "
                    f"{received[-256:]!r}")
            try:
                received.extend(self.exact(1))
            except TimeoutError as error:
                raise TimeoutError(
                    f"RISC OS did not announce 9d readiness; serial tail: "
                    f"{received[-256:]!r}") from error

    def call(self, kind, body=b"", tag=None):
        self.tag += 1
        if tag is None:
            tag = 0xFFFF if kind == 100 else self.tag
        packet = struct.pack("<IBH", len(body) + 7, kind, tag) + body

        # Pace the serial stream, keeping each request contiguous enough for
        # the guest's DeviceFS and UnixLib receive path to retain the frame.
        for byte in packet:
            self.stream.sendall(bytes((byte, )))
            time.sleep(0.01)

        size, reply, reply_tag = struct.unpack("<IBH", self.exact(7))
        body = self.exact(size - 7)
        if reply_tag != tag:
            raise RuntimeError(f"unexpected 9P tag {reply_tag}, wanted {tag}")
        if reply == 107:
            length = struct.unpack_from("<H", body)[0]
            raise RuntimeError(body[2:2 + length].decode("latin-1"))
        if reply != kind + 1:
            raise RuntimeError(f"unexpected 9P reply {reply} for {kind}")
        return body

    def version(self):
        version = b"9P2000.u"
        self.call(100, struct.pack("<IH", 8192, len(version)) + version)

    def attach(self, fid):
        body = struct.pack("<II", fid, 0xFFFFFFFF)
        body += p9_string("mountin") + p9_string("")
        self.call(104, body + struct.pack("<I", 0xFFFFFFFF))

    def walk(self, fid, newfid, name):
        self.call(110, struct.pack("<IIH", fid, newfid, 1) + p9_string(name))

    def walk_path(self, fid, newfid, names):
        body = struct.pack("<IIH", fid, newfid, len(names))
        body += b"".join(p9_string(name) for name in names)
        reply = self.call(110, body)
        walked = struct.unpack_from("<H", reply)[0]
        if walked != len(names):
            raise RuntimeError(
                f"short 9P walk: {walked} of {len(names)} components")

    def open(self, fid, mode=0):
        self.call(112, struct.pack("<IB", fid, mode))

    def create(self, fid, name):
        body = struct.pack("<I", fid) + p9_string(name)
        self.call(114, body + struct.pack("<IB", 0o666, 2) + p9_string(""))

    def read(self, fid, offset=0, count=8192):
        body = self.call(116, struct.pack("<IQI", fid, offset, count))
        length = struct.unpack_from("<I", body)[0]
        return body[4:4 + length]

    def write(self, fid, data):
        body = struct.pack("<IQI", fid, 0, len(data)) + data
        written = struct.unpack("<I", self.call(118, body))[0]
        if written != len(data):
            raise RuntimeError(f"short 9P write: {written} of {len(data)}")

    def clunk(self, fid):
        self.call(120, struct.pack("<I", fid))


def connect(path, process, deadline):
    while time.monotonic() < deadline:
        if process.poll() is not None:
            raise RuntimeError(f"QEMU exited with status {process.returncode}")
        if path.exists():
            stream = socket.socket(socket.AF_UNIX)
            try:
                stream.connect(str(path))
                return stream
            except (ConnectionRefusedError, FileNotFoundError):
                stream.close()
        time.sleep(0.05)
    raise TimeoutError("QEMU did not create the RISC OS serial endpoint")


def boot(qemu, rom, disk, directory, usb=None, cd=None, usb2=None):
    serial = directory / "serial.sock"
    command = [
        str(qemu),
        "-M",
        "raspi2b",
        "-bios",
        str(rom),
        "-drive",
        f"file={disk},format=raw,if=sd",
        "-display",
        "none",
        "-monitor",
        "none",
        "-no-reboot",
        "-chardev",
        f"socket,id=mountin,path={serial},server=on,wait=on",
        "-serial",
        "chardev:mountin",
        "-serial",
        "null",
    ]
    if usb is not None:
        command += [
            "-drive", f"file={usb},format=raw,if=none,id=mountin-usb",
            "-device", "usb-storage,drive=mountin-usb",
        ]
    if cd is not None:
        command += [
            "-drive",
            f"file={cd},format=raw,if=none,id=mountin-cd,media=cdrom,readonly=on",
            "-device", "usb-storage,drive=mountin-cd",
        ]
    if usb2 is not None:
        command += [
            "-drive", f"file={usb2},format=raw,if=none,id=mountin-usb2",
            "-device", "usb-storage,drive=mountin-usb2",
        ]
    process = subprocess.Popen(command)
    try:
        stream = connect(serial, process, time.monotonic() + 30)
        client = Client(stream)
        client.ready()
        client.version()
        return process, stream, client
    except BaseException:
        stop(process)
        raise


def stop(process):
    if process.poll() is None:
        process.terminate()
        try:
            process.wait(timeout=5)
        except subprocess.TimeoutExpired:
            process.kill()
            process.wait()


def initial_test(client):
    client.attach(1)
    client.open(1)
    if "SDFS" not in stat_names(client.read(1)):
        raise RuntimeError("RISC OS did not expose SDFS in the namespace")

    client.attach(2)
    client.walk(2, 3, "SDFS")
    client.open(3)
    if "basic" not in stat_names(client.read(3)):
        raise RuntimeError("RISC OS did not expose the FileCore fixture")

    payload = b"written through RISC OS 9d\n"
    client.attach(4)
    client.walk(4, 7, "SDFS")
    client.create(7, "MtTest01")
    client.write(7, payload)
    client.clunk(7)

    client.attach(5)
    client.walk(5, 8, "SDFS")
    client.walk(8, 6, "MtTest01")
    client.open(6)
    if client.read(6) != payload:
        raise RuntimeError("RISC OS did not retain the 9P write")
    return payload


def persistence_test(client, expected):
    client.attach(1)
    client.walk(1, 3, "SDFS")
    client.walk(3, 2, "MtTest01")
    client.open(2)
    if client.read(2) != expected:
        raise RuntimeError(
            "RISC OS did not persist the 9P write across reboot")


def filecore_read_test(client):
    client.attach(1)
    client.walk(1, 2, "SDFS")
    client.open(2)
    if "basic" not in stat_names(client.read(2)):
        raise RuntimeError("RISC OS did not read the old-map FileCore root")


def imagefs_test(client, image):
    client.attach(1)
    client.walk_path(1, 2, ["SDFS", image])
    client.open(2)
    names = stat_names(client.read(2))
    if "basic" not in {name.lower() for name in names}:
        raise RuntimeError(f"DOSFS did not expose {image} root: {names!r}")

    client.attach(3)
    client.walk_path(3, 4, ["SDFS", image, "BASIC"])
    client.open(4)
    names = stat_names(client.read(4))
    if "hello.txt" not in {name.lower() for name in names}:
        raise RuntimeError(f"DOSFS did not expose {image}/basic: {names!r}")

    client.attach(5)
    client.walk_path(5, 6, ["SDFS", image, "BASIC", "HELLO.TXT"])
    client.open(6)
    if b"Hello" not in client.read(6):
        raise RuntimeError(f"DOSFS returned unexpected data from {image}")


def removable_media_test(client):
    client.attach(1)
    client.open(1)
    roots = stat_names(client.read(1))
    for name in ("SCSI-4", "CDFS"):
        if name not in roots:
            raise RuntimeError(f"RISC OS did not expose {name}: {roots!r}")

    for fid, path, expected in (
        (2, ["SCSI-4", "BASIC", "HELLO.TXT"], b"Hello"),
        (4, ["CDFS", "BASIC", "SCRIPT.SH"], b"Executable script ran successfully!"),
    ):
        client.attach(fid)
        client.walk_path(fid, fid + 1, path)
        client.open(fid + 1)
        data = client.read(fid + 1)
        if expected not in data:
            raise RuntimeError(f"unexpected contents at {'/'.join(path)}: {data!r}")


def two_usb_test(client):
    client.attach(1)
    client.open(1)
    roots = stat_names(client.read(1))
    for name in ("SCSI-4", "SCSI-5"):
        if name not in roots:
            raise RuntimeError(f"RISC OS did not expose {name}: {roots!r}")

    for fid, drive in ((2, "SCSI-5"), (4, "SCSI-4"), (6, "SCSI-5")):
        client.attach(fid)
        client.walk_path(fid, fid + 1, [drive, "BASIC", "HELLO.TXT"])
        client.open(fid + 1)
        if b"Hello" not in client.read(fid + 1):
            raise RuntimeError(f"unexpected contents at {drive}/BASIC/HELLO.TXT")
        client.clunk(fid + 1)
        client.clunk(fid)


def single_cd_test(client):
    client.attach(1)
    client.open(1)
    roots = stat_names(client.read(1))
    if "CDFS" not in roots:
        raise RuntimeError(f"RISC OS did not expose the CD drive: {roots!r}")
    client.attach(2)
    client.walk_path(2, 3, ["CDFS", "BASIC", "SCRIPT.SH"])
    client.open(3)
    if b"Executable script ran successfully!" not in client.read(3):
        raise RuntimeError("unexpected contents in the CD fixture")


def main():
    if len(sys.argv) < 8:
        raise SystemExit(
            "usage: verify.py QEMU ROM FILECORE_IMAGE OLDMAP_IMAGE "
            "USB_IMAGE CD_IMAGE IMAGEFS_HOST...")
    qemu, rom, fixture, oldmap_fixture = map(Path, sys.argv[1:5])
    usb_fixture, cd_fixture = map(Path, sys.argv[5:7])
    image_fixtures = [Path(path) for path in sys.argv[7:]]

    cache = Path(os.environ.get("MOUNTIN_CACHE_DIR", "/host/build/cache"))
    cache.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix="appliance-", dir=cache) as tmp:
        directory = Path(tmp)
        disk = directory / "fixture.img"
        shutil.copyfile(fixture, disk)
        with disk.open("r+b") as stream:
            stream.truncate(32 * 1024 * 1024)

        process, stream, client = boot(qemu, rom, disk, directory)
        try:
            payload = initial_test(client)
        finally:
            stream.close()
            stop(process)

        process, stream, client = boot(qemu, rom, disk, directory)
        try:
            persistence_test(client, payload)
        finally:
            stream.close()
            stop(process)

        shutil.copyfile(oldmap_fixture, disk)
        with disk.open("r+b") as stream:
            stream.truncate(32 * 1024 * 1024)
        process, stream, client = boot(qemu, rom, disk, directory)
        try:
            filecore_read_test(client)
        finally:
            stream.close()
            stop(process)

        for image_fixture in image_fixtures:
            variant = image_fixture.name.removeprefix("basic.filecore-")
            if variant not in {
                    "fat12", "fat12-mbr", "fat16", "fat16-mbr",
                    "fat32", "fat32-mbr", "fat-multi-mbr"}:
                raise ValueError(f"unknown ImageFS fixture: {image_fixture}")
            image_name = ("FATMULTI" if variant == "fat-multi-mbr" else
                          variant.upper().replace("-MBR", "MBR"))
            shutil.copyfile(image_fixture, disk)
            with disk.open("r+b") as stream:
                stream.truncate(1 << (image_fixture.stat().st_size - 1).bit_length())
            process, stream, client = boot(qemu, rom, disk, directory)
            try:
                imagefs_test(client, image_name)
            finally:
                stream.close()
                stop(process)

        shutil.copyfile(fixture, disk)
        with disk.open("r+b") as stream:
            stream.truncate(32 * 1024 * 1024)
        usb_copy = directory / "second-usb.img"
        shutil.copyfile(usb_fixture, usb_copy)
        with usb_copy.open("r+b") as stream:
            stream.seek(39)  # FAT16 volume serial in the boot sector
            stream.write(bytes.fromhex("7145b9c2"))
        process, stream, client = boot(
            qemu, rom, disk, directory, cd=cd_fixture)
        try:
            single_cd_test(client)
        finally:
            stream.close()
            stop(process)

        process, stream, client = boot(
            qemu, rom, disk, directory, usb=usb_fixture, usb2=usb_copy)
        try:
            two_usb_test(client)
        finally:
            stream.close()
            stop(process)

        process, stream, client = boot(
            qemu, rom, disk, directory, usb_fixture, cd_fixture)
        try:
            removable_media_test(client)
        finally:
            stream.close()
            stop(process)

    print(
        "RISC OS FileCore, DOSFS ImageFS, USB SCSIFS and CD CDFS verification complete")


if __name__ == "__main__":
    main()
