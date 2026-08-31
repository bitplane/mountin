---
title: NetBSD Compilers
build_platforms:
  x86_64-linux: {}
  aarch64-linux: {}
provides:
  - docker:builder/compiler/netbsd
---

# NetBSD Compilers

Internal Linux bootstrap used to build versioned NetBSD toolboxes. It contains
only source-independent host packages; NetBSD sources, tools and sysroots live
in the versioned images.
