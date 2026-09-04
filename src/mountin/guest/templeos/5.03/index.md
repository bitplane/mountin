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

Uses Aiwnios to bootstrap TempleOS's compiler from the final source snapshot.
The resulting native compiler builds the kernel, then TempleOS's own RedSea
distribution builder produces the boot media.
