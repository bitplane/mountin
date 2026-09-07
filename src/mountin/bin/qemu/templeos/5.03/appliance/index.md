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
requires:
  - docker:${MOUNTIN_BUILDER}
---

# TempleOS 5.03 mountin appliance

Publishes the source-built TempleOS distribution ISO as a QEMU input. Before
publishing, the real TempleOS kernel mounts the raw RedSea fixture from a QEMU
IDE disk and verifies its contents, then exchanges binary data over an emulated
COM1 connected to a Unix socket.
