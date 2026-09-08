---
title: 9d for RISC OS
requires:
  - docker:${MOUNTIN_BUILDER}
  - sources/9d-0.7.6.tar.xz
provides:
  - bin/${MOUNTIN_TARGET_PLATFORM}/9d
---

# 9d for RISC OS

Socket-free 9d build for RISC OS, compiled against UnixLib by the GCCSDK
toolbox.
