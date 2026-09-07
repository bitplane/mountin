---
format: pt/mbr
requires:
  - docker:builder/disk/guest
  - guest/x86_64-templeos/5.03/fixture/fat32/templeos.iso
provides:
  - data/pt/templeos-fat32.mbr
---

# TempleOS FAT32 MBR Disk

PC hard-disk image containing one active FAT32 partition. The source-built
TempleOS guest formats and populates it using its own block-device and FAT32
implementations.
