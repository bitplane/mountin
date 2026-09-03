---
title: TempleOS 5.03 mountin appliance
env:
  MOUNTIN_BUILDER: builder/disk/guest
output_platforms:
  x86_64-templeos:
    requires:
      - guest/${MOUNTIN_TARGET_PLATFORM}/5.03/templeos.iso
    provides:
      - bin/qemu/${MOUNTIN_TARGET_PLATFORM}/5.03/templeos.iso
requires:
  - docker:${MOUNTIN_BUILDER}
---

# TempleOS 5.03 mountin appliance

Publishes the source-built TempleOS distribution ISO as a QEMU input.
