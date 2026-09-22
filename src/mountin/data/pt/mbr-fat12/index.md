---
format: pt/mbr
requires:
  - docker:builder/disk/alpine
build_requires:
  - data/fs/basic.dosfs-fat12
provides:
  - data/pt/basic-fat12.mbr
---

# MBR FAT12 test image

Single primary FAT12 partition beginning at sector 2048 with DOS type `01`.
This compact fixture
exercises readers that accept a whole disk image and locate one DOS partition.
