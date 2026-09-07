#!/usr/bin/env python3
from pathlib import Path
import struct
import subprocess
import sys
import time


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: verify.py TEMPLEOS_ISO DISK_IMAGE")

    iso, disk = map(Path, sys.argv[1:])
    debug = disk.with_suffix(".debug")
    command = [
        "qemu-system-x86_64", "-machine", "pc,accel=tcg", "-cpu", "max",
        "-m", "512", "-smp", "1", "-display", "none", "-monitor", "none",
        "-no-reboot", "-boot", "d",
        "-drive", f"file={disk},format=raw,if=ide,index=0",
        "-drive", f"file={iso},format=raw,if=ide,index=2,media=cdrom,readonly=on",
        "-debugcon", f"file:{debug}", "-serial", "none",
    ]
    process = subprocess.Popen(command)
    try:
        deadline = time.monotonic() + 120
        while time.monotonic() < deadline:
            if process.poll() is not None:
                raise RuntimeError(f"QEMU exited with status {process.returncode}")
            if debug.exists() and b"DONE" in debug.read_bytes():
                break
            time.sleep(0.05)
        else:
            observed = debug.read_bytes() if debug.exists() else b""
            raise TimeoutError(
                f"TempleOS did not finish the MBR fixture: {observed!r}")
    finally:
        if process.poll() is None:
            process.terminate()
            try:
                process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait()
        debug.unlink(missing_ok=True)

    with disk.open("rb") as stream:
        sector = stream.read(512)
    entry = sector[446:462]
    if sector[510:512] != b"\x55\xaa":
        raise RuntimeError("TempleOS left an invalid MBR signature")
    if entry[0] != 0x80 or entry[4] != 0x0B:
        raise RuntimeError(
            "TempleOS did not publish its active FAT32-labelled RedSea partition")
    start, size = struct.unpack_from("<II", entry, 8)
    if start != 2048 or not size:
        raise RuntimeError("TempleOS changed the fixture partition extent")
    with disk.open("rb") as stream:
        stream.seek(start * 512)
        boot = stream.read(512)
    if boot[3] != 0x88 or boot[510:512] != b"\x55\xaa":
        raise RuntimeError("TempleOS did not format the partition as RedSea")

    print("TempleOS MBR RedSea fixture complete")


if __name__ == "__main__":
    main()
