#!/usr/bin/env python3
import os
from pathlib import Path
import socket
import struct
import subprocess
import sys
import time


def p9_string(value):
    encoded = value.encode()
    return struct.pack("<H", len(encoded)) + encoded


class Client:
    def __init__(self, path):
        self.stream = socket.socket(socket.AF_UNIX)
        self.stream.settimeout(15)
        self.stream.connect(str(path))
        self.tag = 0

    def exact(self, size):
        result = b""
        while len(result) < size:
            chunk = self.stream.recv(size - len(result))
            if not chunk:
                raise EOFError("TempleOS closed the 9P stream")
            result += chunk
        return result

    def call(self, kind, body=b"", tag=None):
        self.tag = (self.tag + 1) % 65535
        if tag is None:
            tag = 65535 if kind == 100 else self.tag
        self.stream.sendall(struct.pack("<IBH", len(body) + 7, kind, tag) + body)
        size = struct.unpack("<I", self.exact(4))[0]
        response = self.exact(size - 4)
        reply, reply_tag = struct.unpack("<BH", response[:3])
        if reply_tag != tag or reply != kind + 1:
            raise RuntimeError(f"unexpected 9P reply {reply}/{reply_tag}")
        return response[3:]

    def version(self):
        return self.call(100, struct.pack("<I", 8192) + p9_string("9P2000"))

    def attach(self, fid=1):
        body = struct.pack("<II", fid, 0xFFFFFFFF)
        return self.call(104, body + p9_string("mountin") + p9_string(""))

    def walk(self, fid, newfid, name):
        body = struct.pack("<IIH", fid, newfid, 1) + p9_string(name)
        return self.call(110, body)

    def clone(self, fid, newfid):
        return self.call(110, struct.pack("<IIH", fid, newfid, 0))

    def open(self, fid, mode=0):
        return self.call(112, struct.pack("<IB", fid, mode))

    def create(self, fid, name):
        body = struct.pack("<I", fid) + p9_string(name)
        return self.call(114, body + struct.pack("<IB", 0o666, 2))

    def read(self, fid, offset, count):
        reply = self.call(116, struct.pack("<IQI", fid, offset, count))
        size = struct.unpack("<I", reply[:4])[0]
        return reply[4:4 + size]

    def write(self, fid, offset, data):
        body = struct.pack("<IQI", fid, offset, len(data)) + data
        reply = self.call(118, body)
        return struct.unpack("<I", reply)[0]

    def remove(self, fid):
        self.call(122, struct.pack("<I", fid))

    def close(self):
        self.stream.close()


def wait_for(path, marker, process, deadline):
    while time.monotonic() < deadline:
        if process.poll() is not None:
            raise RuntimeError(f"QEMU exited with status {process.returncode}")
        if path.exists() and marker in path.read_bytes():
            return
        time.sleep(0.05)
    raise TimeoutError(f"TempleOS did not emit {marker!r}")


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: verify.py TEMPLEOS_ISO REDSEA_IMAGE")

    iso, fixture = map(Path, sys.argv[1:])
    token = os.getpid()
    socket_path = Path(f"/tmp/templeos-serial-{token}.sock")
    debug_path = Path(f"/tmp/templeos-debug-{token}.log")
    command = [
        "qemu-system-x86_64", "-machine", "pc,accel=tcg", "-cpu", "max",
        "-m", "512", "-smp", "1", "-display", "none", "-monitor", "none",
        "-no-reboot", "-boot", "d",
        "-drive", f"file={fixture},format=raw,if=ide,index=0,snapshot=on",
        "-drive", f"file={iso},format=raw,if=ide,index=2,media=cdrom,readonly=on",
        "-debugcon", f"file:{debug_path}",
        "-chardev", f"socket,id=mountin,path={socket_path},server=on,wait=off",
        "-serial", "chardev:mountin",
    ]

    process = subprocess.Popen(command)
    try:
        deadline = time.monotonic() + 120
        wait_for(debug_path, b"READY", process, deadline)
        time.sleep(0.1)
        client = Client(socket_path)
        try:
            client.version()
            client.attach()
            client.walk(1, 2, "hello.txt")
            client.open(2)
            if client.read(2, 0, 64) != b"Hello, world!\n":
                raise RuntimeError("TempleOS returned the wrong fixture contents")
            client.clone(1, 3)
            client.create(3, "mountin-test")
            payload = b"TempleOS 9P write verified\n"
            if client.write(3, 0, payload) != len(payload):
                raise RuntimeError("TempleOS returned a short 9P write")
            if client.read(3, 0, len(payload)) != payload:
                raise RuntimeError("TempleOS did not retain the 9P write")
            client.remove(3)
        finally:
            client.close()
    finally:
        if process.poll() is None:
            process.terminate()
            try:
                process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait()
        socket_path.unlink(missing_ok=True)
        debug_path.unlink(missing_ok=True)

    print("TempleOS RedSea read/write over 9P complete")


if __name__ == "__main__":
    main()
