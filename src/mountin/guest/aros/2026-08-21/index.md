---
title: AROS 2026-08-21 guest components
output_platforms:
  i386-aros:
    requires:
      - docker:${MOUNTIN_BUILDER}
      - sources/aros-ports/acpica-unix-20260408.tar.gz
      - sources/aros-ports/grub-2.12.tar.gz
      - sources/aros-ports/pci.ids
    provides:
      - guest/i386-aros/2026-08-21/aros.iso
  aarch64-aros:
    requires:
      - docker:${MOUNTIN_BUILDER}
      - sources/linux-6.12.tar.xz
    provides:
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
      - guest/aarch64-aros/2026-08-21/locale.library
      - guest/aarch64-aros/2026-08-21/iffparse.library
      - guest/aarch64-aros/2026-08-21/usergroup.library
requires:
  - sources/aros-2026-08-21.tar.gz
  - sources/aros-ports/UnicodeData.txt
  - sources/aros-ports/SpecialCasing.txt
---

# AROS 2026-08-21 guest components

Builds the operating-system components needed by each AROS target. PC i386
produces a bootable ISO. Raspberry Pi AArch64 produces its native kernel, BSP
module package, firmware configuration, and a device tree compiled from the
Linux source already used by Mountin. No Raspberry Pi firmware binaries are
downloaded.
