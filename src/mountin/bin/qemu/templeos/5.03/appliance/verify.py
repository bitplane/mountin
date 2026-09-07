#!/usr/bin/env python3
import os
from pathlib import Path
import socket
import subprocess
import sys
import time


READY = b"MOUNTIN: SERIAL READY\n"
REDSEA_COMPLETE = b"MOUNTIN: REDSEA COMPLETE\n"
SERIAL_COMPLETE = b"MOUNTIN: SERIAL COMPLETE\n"
CHALLENGE = bytes((0x00, 0x01, 0x7F, 0x80, 0xFE, 0xFF, 0x55, 0xAA))
RESPONSE = bytes(value ^ 0xA5 for value in CHALLENGE)


def receive_until(stream, marker, deadline, received=b""):
    while marker not in received:
        remaining = deadline - time.monotonic()
        if remaining <= 0:
            raise TimeoutError(f"TempleOS did not emit {marker!r}: {received!r}")
        stream.settimeout(min(remaining, 1.0))
        try:
            chunk = stream.recv(4096)
        except TimeoutError:
            continue
        if not chunk:
            raise RuntimeError(f"TempleOS serial stream closed: {received!r}")
        received += chunk
    return received


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: verify.py TEMPLEOS_ISO REDSEA_IMAGE")

    iso = Path(sys.argv[1])
    fixture = Path(sys.argv[2])
    socket_path = Path(f"/tmp/templeos-serial-{os.getpid()}.sock")
    command = [
        "qemu-system-x86_64",
        "-machine", "pc,accel=tcg",
        "-cpu", "max",
        "-m", "512",
        "-smp", "1",
        "-display", "none",
        "-monitor", "none",
        "-no-reboot",
        "-boot", "d",
        "-drive", f"file={fixture},format=raw,if=ide,index=0,snapshot=on",
        "-drive", f"file={iso},format=raw,if=ide,index=2,media=cdrom,readonly=on",
        "-chardev", f"socket,id=mountin,path={socket_path},server=on,wait=off",
        "-serial", "chardev:mountin",
    ]

    process = subprocess.Popen(command)
    try:
        deadline = time.monotonic() + 120
        while not socket_path.exists():
            if process.poll() is not None:
                raise RuntimeError(f"QEMU exited with status {process.returncode}")
            if time.monotonic() >= deadline:
                raise TimeoutError("QEMU did not create the TempleOS serial socket")
            time.sleep(0.05)

        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as stream:
            stream.connect(str(socket_path))
            received = receive_until(stream, READY, deadline)
            if REDSEA_COMPLETE not in received:
                raise RuntimeError(f"TempleOS did not verify RedSea: {received!r}")
            received = received[received.index(READY) + len(READY):]
            stream.sendall(CHALLENGE)
            received = receive_until(stream, SERIAL_COMPLETE, deadline, received)
            if not received.startswith(RESPONSE):
                raise RuntimeError(f"TempleOS returned the wrong binary response: {received!r}")
    finally:
        if process.poll() is None:
            process.terminate()
            try:
                process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait()
        socket_path.unlink(missing_ok=True)

    print("TempleOS RedSea and serial verification complete")


if __name__ == "__main__":
    main()
