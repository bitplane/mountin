---
format: pt/mbr
requires:
  - docker:builder/disk/guest
  - guest/x86_64-templeos/5.03/fixture/templeos.iso
provides:
  - data/pt/templeos-redsea.mbr
---

# TempleOS RedSea MBR Disk

PC hard-disk image containing one active RedSea partition. The source-built
TempleOS guest formats and populates it using its own block-device and RedSea
implementations. TempleOS labels the partition as FAT32 type `0x0b` for boot
compatibility; the partition's boot sector carries the RedSea `0x88` signature.
