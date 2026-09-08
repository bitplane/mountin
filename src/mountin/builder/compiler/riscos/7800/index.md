---
title: RISC OS GCCSDK r7800 Toolbox
build_platforms:
  x86_64-linux: {}
  aarch64-linux: {}
output_platforms:
  arm-riscos:
    provides:
      - docker:builder/compiler/riscos/7800
requires:
  - docker:builder/compiler/riscos
build_requires:
  - sources/gccsdk-7800.tar.gz
  - sources/autoconf-2.64.tar.bz2
  - sources/automake-1.11.1.tar.bz2
  - sources/libtool-2.4.2.tar.gz
  - sources/binutils-2.24.tar.bz2
  - sources/gcc-4.7.4.tar.bz2
  - sources/gmp-5.0.1.tar.bz2
  - sources/mpc-1.1.0.tar.gz
  - sources/mpfr-3.0.1.tar.bz2
---

# RISC OS GCCSDK r7800 Toolbox

GCCSDK's GCC 4.7.4 cross-compiler, binutils, UnixLib and RISC OS host tools,
built from the canonical r7800 source snapshot. Every upstream archive is a
catalogue input; the build performs no network access.

The toolbox builds only the C compiler and static target libraries required by
Mountin appliances. It exposes the usual source, build and sysroot views under
`/opt/mountin`, and installs the cross tools in `PATH`.
