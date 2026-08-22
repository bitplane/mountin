---
title: AROS Raspberry Pi AArch64 Base Guest
env:
  MOUNTIN_BUILDER: builder/disk/alpine
requires:
  - docker:${MOUNTIN_BUILDER}
  - guest/aarch64-aros/2026-08-21/aros-aarch64-raspi.img
  - guest/aarch64-aros/2026-08-21/aros-aarch64-bsp.rom
  - guest/aarch64-aros/2026-08-21/config.txt
provides:
  - bin/qemu/aarch64-aros/2026-08-21/aros-aarch64-raspi.img
  - bin/qemu/aarch64-aros/2026-08-21/aros-aarch64-bsp.rom
  - bin/qemu/aarch64-aros/2026-08-21/config.txt
  - bin/qemu/aarch64-aros/2026-08-21/system.img
---

# AROS Raspberry Pi AArch64 Base Guest

QEMU boot components and a minimal FAT system volume for AROS AArch64. This is
the bring-up guest; its 9P appliance transport remains pending until the AROS
Raspberry Pi target has a bidirectional guest device suitable for 9d.
