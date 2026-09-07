---
title: TempleOS 5.03 mountin appliance
env:
  MOUNTIN_BUILDER: builder/disk/guest
output_platforms:
  x86_64-templeos:
    requires:
      - guest/${MOUNTIN_TARGET_PLATFORM}/5.03/templeos.iso
      - data/fs/basic.redsea
    provides:
      - bin/qemu/${MOUNTIN_TARGET_PLATFORM}/5.03/templeos.iso
support:
  - format/fs/redsea
  - transport/9p
requires:
  - docker:${MOUNTIN_BUILDER}
---

# TempleOS 5.03 mountin appliance

Publishes the source-built TempleOS distribution ISO as a QEMU input. Before
publishing, the real TempleOS kernel mounts the raw RedSea fixture from a QEMU
IDE disk and serves it with the released temple9p server. Verification reads and
mutates the filesystem using 9P2000 over an emulated COM1.
