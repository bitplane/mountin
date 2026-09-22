---
format: pt/mbr
requires:
  - docker:builder/disk/alpine
build_requires:
  - data/fs/basic.dosfs-fat12
  - data/fs/basic.fat16
  - data/fs/basic.fat32
provides:
  - data/pt/basic-fat12.mbr
  - data/pt/basic-fat16.mbr
  - data/pt/basic-fat32.mbr
  - data/pt/basic-fat-multi.mbr
---

# MBR DOSFS test images

Each image contains one primary FAT partition beginning at sector 2048. FAT12
uses a bootable DOS type `01` entry; FAT16 and FAT32 use nonbootable entries of
types `06` and `0c`. These exercise both partition selection paths in DOSFS.
The mixed image places nonbootable FAT16 first and bootable FAT12 second to
check that DOSFS selects the active entry rather than the first entry.
