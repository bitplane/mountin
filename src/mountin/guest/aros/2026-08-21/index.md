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
    provides:
      - guest/aarch64-aros/2026-08-21/aros-aarch64-raspi.img
      - guest/aarch64-aros/2026-08-21/aros-aarch64-bsp.rom
      - guest/aarch64-aros/2026-08-21/config.txt
requires:
  - sources/aros-2026-08-21.tar.gz
---

# AROS 2026-08-21 guest components

Builds the operating-system components needed by each AROS target. PC i386
produces a bootable ISO. Raspberry Pi AArch64 produces its native kernel, BSP
module package, and firmware configuration without downloading Raspberry Pi
firmware; QEMU supplies the board firmware and device tree.
