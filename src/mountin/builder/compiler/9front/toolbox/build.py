import argparse
import subprocess
import tempfile
from pathlib import Path

import pexpect


def command(*args: str) -> None:
    subprocess.run(args, check=True)


def run_guest(qemu: pexpect.spawn, command_text: str) -> None:
    qemu.sendline(f"{{{command_text}}}; command_status=$status; "
                  "if(~ $\"command_status '') echo MOUNTIN_^COMMAND_OK; "
                  "if(! ~ $\"command_status '') echo MOUNTIN_^COMMAND_FAILED")
    result = qemu.expect([r"MOUNTIN_COMMAND_OK", r"MOUNTIN_COMMAND_FAILED"],
                         timeout=3600)
    qemu.expect(r"term% ", timeout=3600)
    if result:
        raise RuntimeError(f"9front command failed: {command_text}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--target",
                        choices=("x86_64", "aarch64"),
                        required=True)
    parser.add_argument("--source", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("script", type=Path)
    args = parser.parse_args()

    source = args.source.resolve(strict=True)
    script = args.script.resolve(strict=True)
    args.output.mkdir(parents=True, exist_ok=True)
    objtype = "amd64" if args.target == "x86_64" else "arm64"

    with tempfile.TemporaryDirectory(prefix="9front-build-",
                                     dir="/work") as raw:
        work = Path(raw)
        source_archive = work / "source.tar.gz"
        source_iso = work / "source.iso"
        output_image = work / "output.fat"
        system_image = work / "system.qcow2"

        command("tar", "-czf", str(source_archive), "-C", str(source.parent),
                source.name)
        command(
            "genisoimage",
            "-quiet",
            "-R",
            "-J",
            "-graft-points",
            "-o",
            str(source_iso),
            f"source.tar.gz={source_archive}",
            f"build.rc={script}",
        )
        command(
            "qemu-img",
            "create",
            "-f",
            "qcow2",
            "-F",
            "qcow2",
            "-b",
            "/opt/9front/bootstrap.qcow2",
            str(system_image),
        )
        command("truncate", "-s", "1536M", str(output_image))
        command("mkfs.vfat", "-F", "32", "-n", "MOUNTINOUT", str(output_image))

        qemu = pexpect.spawn(
            "qemu-system-x86_64",
            [
                "-machine",
                "q35,accel=kvm:tcg",
                "-cpu",
                "max",
                "-m",
                "1024",
                "-smp",
                "2",
                "-display",
                "none",
                "-monitor",
                "none",
                "-serial",
                "stdio",
                "-no-reboot",
                "-drive",
                f"file={system_image},if=virtio,format=qcow2",
                "-drive",
                f"file={source_iso},media=cdrom,format=raw",
                "-drive",
                f"file={output_image},if=virtio,format=raw",
            ],
            encoding="utf-8",
            codec_errors="replace",
            timeout=3600,
        )
        try:
            qemu.expect("bootargs is")
            qemu.sendline("local!/dev/sdF0/fs")
            qemu.expect("user")
            qemu.sendline("glenda")
            qemu.expect(r"term% ")
            for guest_command in (
                    "mkdir -p /n/src /n/out /tmp/mountin-source",
                    "9660srv -f /dev/sdE0/data mountinsrc",
                    "mount /srv/mountinsrc /n/src",
                    "dossrv -f /dev/sdG0/data mountinout",
                    "mount -c /srv/mountinout /n/out",
                    "cd /tmp/mountin-source; tar xzf /n/src/source.tar.gz",
                    f"objtype={objtype}; cd /tmp/mountin-source/*; rc /n/src/build.rc",
            ):
                run_guest(qemu, guest_command)
        finally:
            qemu.close(force=True)

        command("mcopy", "-s", "-n", "-i", str(output_image), "::*",
                str(args.output))


if __name__ == "__main__":
    main()
