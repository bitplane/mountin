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
      - data/fs/basic.filecore-oldmap-newdir
      - data/fs/basic.fat16
      - data/fs/basic.iso9660
      - data/fs/basic.filecore-fat12
      - data/fs/basic.filecore-fat12-mbr
      - data/fs/basic.filecore-fat16
      - data/fs/basic.filecore-fat16-mbr
      - data/fs/basic.filecore-fat32
      - data/fs/basic.filecore-fat32-mbr
      - data/fs/basic.filecore-fat-multi-mbr
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
beneath that root. The SD card appears at `/SDFS`, backed by `SDFS::0.$`.
Whole-device new-map and old-map new-directory FileCore filesystems pass the
guest read checks. The old-map old-directory FileCore fixture returns an I/O
error through SDFS.
FAT12, FAT16 and FAT32 image files, each raw or containing an MBR and FAT
partition, pass fixture-backed 9P enumeration and reads through DOSFS ImageFS.
A mixed MBR checks that DOSFS selects an active second partition. Whole-device
partitioned media still need a driver path and tests.

The ROM now includes the USB SCSI and CDFS modules. A USB FAT16 disk appears
at `/SCSI-4` and an ISO 9660 CD at `/CDFS`; single-file 9P reads of both
fixtures have passed in the experimental ROM. The fixture-backed appliance
test exercises both media in one boot. A subsequent request can stall during
removable-media access. Separate fixture-backed tests boot with only a CD and
switch between two USB disks with distinct FAT volume serials. The CD-only
boot does not expose `/CDFS`. Alternating USB reads can pass, but later
requests can stall after closing a file or while 9d refreshes its namespace,
so this build has not passed its release gate.

Before publication, verification pads a disposable copy of the new-map
FileCore fixture to the power-of-two SD-card capacity required by QEMU. It
boots the ROM, reads and mutates the filesystem over 9P, reboots with the same
disk, and proves that the mutation persisted. It reads an old-map
new-directory fixture and boots with each DOSFS fixture to check ImageFS root
and child enumeration and file contents. It also attaches USB FAT16 and ISO
9660 fixtures and checks their namespace roots and file contents over 9P.
