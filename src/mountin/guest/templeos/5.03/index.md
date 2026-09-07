---
title: TempleOS 5.03 guest components
output_platforms:
  x86_64-templeos:
    requires:
      - docker:builder/compiler/templeos/5.03
      - bin/x86_64-templeos/temple9p/Temple9P.HC
      - bin/x86_64-templeos/temple9p/Serial.HC
      - data/templates/basic.tar
    provides:
      - guest/x86_64-templeos/5.03/templeos.iso
      - guest/x86_64-templeos/5.03/fixture/redsea/templeos.iso
      - guest/x86_64-templeos/5.03/fixture/fat32/templeos.iso
---

# TempleOS 5.03 guest components

Uses Aiwnios to bootstrap TempleOS's compiler from the final source snapshot.
The resulting native compiler builds the kernel, then TempleOS's own RedSea
distribution builder produces boot media containing the released temple9p
server. The same compiled distribution tree also produces one-shot fixture
media used to create native disk images.
