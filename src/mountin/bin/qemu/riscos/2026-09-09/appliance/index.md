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
the compiled OS. The ROM embeds 9d in ResourceFS and serves the selected
volume over the first PL011 serial port. The current launcher selects
`SDFS::0.$` explicitly. The verified layout is a whole-device, new-map
FileCore filesystem. Other RISC OS filing-system drivers are documented in the
guest component definition; they are not selected for this ROM because their
device paths have not passed appliance tests. The old-map FileCore fixture
currently returns an I/O error through SDFS. Partitioned media, FAT image
files, and CD media need their respective driver paths, runtime root selection,
and fixture-backed 9P tests.

Before publication, verification pads a disposable copy of the new-map
FileCore fixture to the power-of-two SD-card capacity required by QEMU. It
boots the ROM, reads and mutates the filesystem over 9P, reboots with the same
disk, and proves that the mutation persisted.
