---
title: AROS binaries
build_platforms:
  x86_64-linux: {}
  aarch64-linux: {}
output_platforms:
  i386-aros: {}
  aarch64-aros: {}
env:
  MOUNTIN_BUILDER: builder/compiler/aros/2026-08-24/${MOUNTIN_TARGET_ARCH}
---

# AROS binaries

Programs built for AROS guests using the Developer tree in the matching
source-pinned compiler toolbox.
