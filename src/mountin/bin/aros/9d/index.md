---
title: 9d for AROS
requires:
  - docker:${MOUNTIN_BUILDER}
  - sources/9d-0.7.2.tar.xz
provides:
  - bin/${MOUNTIN_TARGET_ARCH}-aros/9d
---

# 9d for AROS

Socket-free 9d build for AROS. Its platform adapter discovers mounted DOS
volumes whenever the synthetic `/` is listed. It is compiled with the SDK
contained in the AROS compiler toolbox.
