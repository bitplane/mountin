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
  - data/pt/basic-fat16-fat32.mbr
  - data/pt/basic-fat-extended.mbr
---

# MBR DOSFS test images

Each image contains one primary FAT partition beginning at sector 2048. FAT12
uses a bootable DOS type `01` entry; FAT16 and FAT32 use nonbootable entries of
types `06` and `0c`. These exercise both partition selection paths in DOSFS.
The mixed image places nonbootable FAT16 first and bootable FAT12 second to
check that DOSFS selects the active entry rather than the first entry.

`basic-fat16-fat32.mbr` contains FAT16 and FAT32 primary partitions.
`basic-fat-extended.mbr` contains a FAT16 primary partition and FAT12 and
FAT32 logical partitions in an extended partition. These two images include
a distinct `PART.TXT` marker in each filesystem (`FAT12 partition`,
`FAT16 partition` or `FAT32 partition`) to verify whole-device partition
offsets, including both links in the EBR chain.
