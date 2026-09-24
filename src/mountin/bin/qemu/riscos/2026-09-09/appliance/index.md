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
      - data/fs/basic.fat12
      - data/fs/basic.fat32
      - data/fs/basic.iso9660
      - data/fs/basic.joliet.iso9660
      - data/fs/basic.rock-ridge.iso9660
      - data/fs/basic.highsierra
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
  - format/fs/fat16
  - format/fs/fat32
  - format/fs/iso9660
  - format/fs/highsierra
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

The ROM includes the USB SCSI and CDFS modules. The fixture-backed verifier
reads FAT12, FAT16 and FAT32 disks at `/SCSI-4`, and plain ISO 9660, Joliet,
Rock Ridge and High Sierra CDs at `/CDFS`. It checks paged Joliet and High
Sierra directories, reads files from them, and alternates reads and closes
between two disks with distinct FAT volume serials. It tests the CD alone and
with a USB disk. The pinned CDFSSoftSCSI MODE SENSE fix keeps the driver from
treating response padding as additional mode pages. The RISC OS serial
transport retries when the output queue is full; the verifier still paces
incoming request bytes at 10 ms so DeviceFS retains each frame.

Before publication, verification pads a disposable copy of the new-map
FileCore fixture to the power-of-two SD-card capacity required by QEMU. It
boots the ROM, reads and mutates the filesystem over 9P, reboots with the same
disk, and proves that the mutation persisted. It reads an old-map
new-directory fixture and boots with each DOSFS fixture to check ImageFS root
and child enumeration and file contents. It also attaches USB FAT16 and ISO
9660 fixtures, plus FAT12 and FAT32 USB and Joliet, Rock Ridge and High Sierra
CD fixtures, and checks their namespace roots and file contents over 9P.

This verifies the listed RISC OS paths, not every image in the global test
catalogue. FAT12 directory enumeration now completes, but the guest returns
`nested_dir` four times in that fixture; FAT12 is not yet declared in the
capability list. An optical UDF fixture does not expose a CDFS root. The
old-map old-directory FileCore fixture returns an I/O error, and the BCM2835
ROM has no PartMan driver for whole-device MBR or GPT media. Those cases need
further investigation before this guest can claim them.
