---
title: RISC OS BCM2835 2026-09-09 mountin appliance
env:
  MOUNTIN_BUILDER: builder/compiler/riscos/2026-09-09
output_platforms:
  arm-riscos:
    requires:
      - guest/${MOUNTIN_TARGET_PLATFORM}/2026-09-09/system
      - bin/${MOUNTIN_TARGET_PLATFORM}/9d
      - data/fs/basic.filecore
      - data/fs/basic.filecore-fat12
      - data/fs/basic.filecore-fat12-mbr
      - bin/qemu-system/${MOUNTIN_BUILD_ARCH}-linux-musl/qemu-system-arm
    provides:
      - bin/qemu/${MOUNTIN_TARGET_PLATFORM}/2026-09-09/rom
support:
  - format/fs/filecore
  - transport/9p
requires:
  - docker:${MOUNTIN_BUILDER}
---

# RISC OS BCM2835 2026-09-09 mountin appliance

Assembles the prepared OS components into a BCM2835 ROM, adding 9d and its
launcher. Resource generation and final linking run here so 9d updates reuse
the compiled OS. The ROM embeds 9d in ResourceFS and serves a synthetic root
over the first PL011 serial port. Each active RISC OS filing system appears
beneath that root; the current ROM exposes the SD card as `/SDFS`, backed by
`SDFS::0.$`. The verified layout is a whole-device, new-map FileCore
filesystem. Other RISC OS filing-system drivers are documented in the guest
component definition; their device paths have not passed appliance tests. The
old-map FileCore fixture currently returns an I/O error through SDFS.
FAT12 image files, including one containing an MBR and FAT partition, pass
fixture-backed 9P enumeration and reads through DOSFS ImageFS. Whole-device
partitioned media and CD media still need their driver paths and tests.

Before publication, verification pads a disposable copy of the new-map
FileCore fixture to the power-of-two SD-card capacity required by QEMU. It
boots the ROM, reads and mutates the filesystem over 9P, reboots with the same
disk, and proves that the mutation persisted. It also boots with each DOSFS
fixture and checks ImageFS root and child enumeration and file contents.
