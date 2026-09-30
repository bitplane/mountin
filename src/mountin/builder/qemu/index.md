---
title: QEMU Cross-Compiler
build_platforms:
  x86_64-linux: {}
  aarch64-linux: {}
requires:
  - sources/qemu-10.2.3.tar.gz
  - sources/glib-2.82.4.tar.xz
  - sources/pixman-0.44.2.tar.gz
  - sources/libffi-3.4.6.tar.gz
  - sources/libiconv-1.17.tar.gz
output_platforms:
  x86_64-linux-musl:
    provides:
      - bin/qemu-system/x86_64-linux-musl/qemu-system-x86_64
      - bin/qemu-system/x86_64-linux-musl/qemu-system-aarch64
      - bin/qemu-system/x86_64-linux-musl/qemu-system-arm
      - bin/qemu-system/x86_64-linux-musl/qemu-system-m68k
      - bin/qemu-system/x86_64-linux-musl/qemu-img
  aarch64-linux-musl:
    provides:
      - bin/qemu-system/aarch64-linux-musl/qemu-system-x86_64
      - bin/qemu-system/aarch64-linux-musl/qemu-system-aarch64
      - bin/qemu-system/aarch64-linux-musl/qemu-system-arm
      - bin/qemu-system/aarch64-linux-musl/qemu-system-m68k
      - bin/qemu-system/aarch64-linux-musl/qemu-img
  x86_64-windows-gnu:
    provides:
      - bin/qemu-system/x86_64-windows-gnu/qemu-system-x86_64.exe
      - bin/qemu-system/x86_64-windows-gnu/qemu-system-aarch64.exe
      - bin/qemu-system/x86_64-windows-gnu/qemu-system-arm.exe
      - bin/qemu-system/x86_64-windows-gnu/qemu-system-m68k.exe
      - bin/qemu-system/x86_64-windows-gnu/qemu-img.exe
  x86_64-darwin:
    requires:
      - sdk/darwin/11.3/MacOSX11.3.sdk
    provides:
      - bin/qemu-system/x86_64-darwin/qemu-system-x86_64
      - bin/qemu-system/x86_64-darwin/qemu-system-aarch64
      - bin/qemu-system/x86_64-darwin/qemu-system-arm
      - bin/qemu-system/x86_64-darwin/qemu-system-m68k
      - bin/qemu-system/x86_64-darwin/qemu-img
---

# QEMU Cross-Compiler

Builds QEMU system emulators and `qemu-img` for all host platforms using Zig
as a cross-compiler. Linux and Windows outputs are static; Darwin outputs
use the system libraries required by macOS. Dependencies (glib, pixman) are built from source
for each target.

## Targets

QEMU emulator targets:
- x86_64-softmmu
- aarch64-softmmu
- arm-softmmu
- m68k-softmmu

## Host Platforms

- x86_64-linux-musl
- x86_64-windows-gnu (MinGW)
- x86_64-darwin

## Shared QEMU source

All emulator architectures, host platforms and the image utility use the
immutable release declared by `sources/qemu-10.2.3`. Guest and disk-building
containers copy their declared native binaries from this provider, including
Debian disk tools, Linux guest disk builders, the 9front bootstrap and the
NetBSD LFS fixture builder. They do not install distribution QEMU packages.
PC firmware is extracted separately from that same source pin and installed
in booting containers at `/usr/share/qemu`.

The fork's `mountin` branch composes the shared stable release. Independent
upstream contribution branches may use the upstream development base for
review; they are not separate guest-specific releases.

The shared build explicitly enables the disk-format drivers: Bochs, cloop,
DMG, QCOW1, QED, VDI, VHDX, VMDK, VPC, virtual FAT and Parallels. These are
required by the image fixture providers and remain enabled alongside raw and
QCOW2 when optional default features are disabled.
