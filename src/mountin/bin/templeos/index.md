---
title: TempleOS binaries
build_platforms:
  x86_64-linux: {}
output_platforms:
  x86_64-templeos: {}
env:
  MOUNTIN_BUILDER: builder/compiler/templeos/5.03
requires:
  - docker:${MOUNTIN_BUILDER}
---

# TempleOS binaries

Native HolyC programs checked with the source-built TempleOS 5.03 toolbox and
published for inclusion in TempleOS guests.
