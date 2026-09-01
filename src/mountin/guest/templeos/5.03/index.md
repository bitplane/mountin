---
title: TempleOS 5.03 guest components
output_platforms:
  x86_64-templeos:
    requires:
      - docker:builder/compiler/templeos/5.03
    provides:
      - guest/x86_64-templeos/5.03/templeos.iso
---

# TempleOS 5.03 guest components

Builds TempleOS's compiler and kernel from the final source snapshot, then uses
the operating system's own RedSea distribution builder to produce boot media.
