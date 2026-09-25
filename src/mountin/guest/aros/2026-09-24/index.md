---
title: AROS 2026-09-24 guest components
output_platforms:
  i386-aros:
    requires:
      - docker:${MOUNTIN_BUILDER}
    provides:
      - guest/i386-aros/2026-09-24/aros.iso
  aarch64-aros:
    requires:
      - docker:${MOUNTIN_BUILDER}
    provides:
      - guest/aarch64-aros/2026-09-24/aros-aarch64-raspi.img
      - guest/aarch64-aros/2026-09-24/aros-aarch64-bsp.rom
      - guest/aarch64-aros/2026-09-24/bcm2837-rpi-3-b.dtb
      - guest/aarch64-aros/2026-09-24/config.txt
      - guest/aarch64-aros/2026-09-24/rawio-handler
      - guest/aarch64-aros/2026-09-24/Automount
      - guest/aarch64-aros/2026-09-24/Mount
      - guest/aarch64-aros/2026-09-24/stdc.library
      - guest/aarch64-aros/2026-09-24/stdcio.library
      - guest/aarch64-aros/2026-09-24/posixc.library
      - guest/aarch64-aros/2026-09-24/locale.library
      - guest/aarch64-aros/2026-09-24/iffparse.library
      - guest/aarch64-aros/2026-09-24/usergroup.library
---

# AROS 2026-09-24 guest components

Builds the operating-system components needed by each AROS target. PC i386
produces a bootable ISO. Raspberry Pi AArch64 produces its native kernel, BSP
module package, firmware configuration, and a device tree compiled from the
Linux source already used by Mountin. No Raspberry Pi firmware binaries are
downloaded.
