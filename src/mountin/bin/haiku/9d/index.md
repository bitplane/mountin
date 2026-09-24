---
title: 9d for Haiku
requires:
  - sources/9d-0.9.3.tar.xz
provides:
  - bin/${MOUNTIN_TARGET_ARCH}-haiku/9d
---

# 9d for Haiku

POSIX 9d build for Haiku, configured for its connected serial stream.
The network transport is disabled; bundled libixp still requires Haiku's
libnetwork for its socket symbols.
