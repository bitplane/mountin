---
title: temple9p for TempleOS 5.03
output_platforms:
  x86_64-templeos:
    requires:
      - sources/temple9p-0.1.0.tar.xz
    provides:
      - bin/${MOUNTIN_TARGET_PLATFORM}/temple9p/Temple9P.HC
      - bin/${MOUNTIN_TARGET_PLATFORM}/temple9p/Serial.HC
---

# temple9p for TempleOS 5.03

Released native HolyC 9P2000 server and serial transport. The TempleOS toolbox
compile-checks the sources before publishing them for guest assembly.
