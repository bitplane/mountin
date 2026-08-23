---
title: AROS Raspberry Pi AArch64 Base Guest
env:
  MOUNTIN_BUILDER: builder/disk/alpine
requires:
  - docker:${MOUNTIN_BUILDER}
  - guest/aarch64-aros/2026-08-21/aros-aarch64-raspi.img
  - guest/aarch64-aros/2026-08-21/aros-aarch64-bsp.rom
  - guest/aarch64-aros/2026-08-21/bcm2837-rpi-3-b.dtb
  - guest/aarch64-aros/2026-08-21/config.txt
  - guest/aarch64-aros/2026-08-21/rawio-handler
  - guest/aarch64-aros/2026-08-21/Automount
  - guest/aarch64-aros/2026-08-21/Mount
  - guest/aarch64-aros/2026-08-21/stdc.library
  - guest/aarch64-aros/2026-08-21/stdcio.library
  - guest/aarch64-aros/2026-08-21/posixc.library
  - bin/aarch64-aros/9d
provides:
  - bin/qemu/aarch64-aros/2026-08-21/aros-aarch64-raspi.img
  - bin/qemu/aarch64-aros/2026-08-21/aros-aarch64-bsp.rom
  - bin/qemu/aarch64-aros/2026-08-21/bcm2837-rpi-3-b.dtb
  - bin/qemu/aarch64-aros/2026-08-21/config.txt
  - bin/qemu/aarch64-aros/2026-08-21/system.img
---

# AROS Raspberry Pi AArch64 Base Guest

QEMU boot components and a minimal FAT system volume for AROS AArch64. A small
DOS handler exposes the kernel's bidirectional debug UART as a stream for 9d.
The system volume also carries the non-resident commands needed to mount that
handler and discover attached volumes.
Startup writes a readiness marker to the UART immediately before entering 9d.
