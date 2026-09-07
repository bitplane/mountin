---
title: TempleOS 5.03 mountin appliance
env:
  MOUNTIN_BUILDER: builder/disk/guest
output_platforms:
  x86_64-templeos:
    requires:
      - guest/${MOUNTIN_TARGET_PLATFORM}/5.03/templeos.iso
      - data/fs/basic.redsea
      - data/pt/templeos-redsea.mbr
      - data/pt/templeos-fat32.mbr
    provides:
      - bin/qemu/${MOUNTIN_TARGET_PLATFORM}/5.03/templeos.iso
support:
  - format/fs/redsea
  - format/fs/fat32
  - format/pt/mbr
  - transport/9p
requires:
  - docker:${MOUNTIN_BUILDER}
---

# TempleOS 5.03 mountin appliance

Publishes the source-built TempleOS distribution ISO as a QEMU input. Before
publishing, the real TempleOS kernel mounts raw RedSea plus conventional
MBR-partitioned RedSea and FAT32 disks from a QEMU IDE drive and serves them
with the released temple9p server. Verification reads and mutates every layout
using 9P2000 over an emulated COM1.
