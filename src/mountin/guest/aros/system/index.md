---
title: AROS 2026-09-24 guest components
output_platforms:
  i386-aros:
    requires:
      - docker:${MOUNTIN_BUILDER}
    provides:
      - guest/i386-aros/aros.iso
  aarch64-aros:
    requires:
      - docker:${MOUNTIN_BUILDER}
    provides:
      - guest/aarch64-aros/aros-aarch64-raspi.img
      - guest/aarch64-aros/aros-aarch64-bsp.rom
      - guest/aarch64-aros/bcm2837-rpi-3-b.dtb
      - guest/aarch64-aros/config.txt
      - guest/aarch64-aros/rawio-handler
      - guest/aarch64-aros/Automount
      - guest/aarch64-aros/Mount
      - guest/aarch64-aros/stdc.library
      - guest/aarch64-aros/stdcio.library
      - guest/aarch64-aros/posixc.library
      - guest/aarch64-aros/locale.library
      - guest/aarch64-aros/iffparse.library
      - guest/aarch64-aros/usergroup.library
---

# AROS 2026-09-24 guest components

Builds the operating-system components needed by each AROS target. PC i386
produces a bootable ISO. Raspberry Pi AArch64 produces its native kernel, BSP
module package, firmware configuration, and a device tree compiled from the
Linux source already used by Mountin. No Raspberry Pi firmware binaries are
downloaded.
