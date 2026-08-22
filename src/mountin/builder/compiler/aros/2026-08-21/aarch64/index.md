---
title: AROS 2026-08-21 Raspberry Pi AArch64 Cross-Compiler
env:
  MOUNTIN_BUILDER: builder/compiler/aros
execution_env:
  MOUNTIN_BUILD_JOBS: ${MOUNTIN_BUILD_JOBS}
requires:
  - docker:${MOUNTIN_BUILDER}
build_requires:
  - sources/aros-2026-08-21.tar.gz
  - sources/aros-ports/binutils-2.32.tar.bz2
  - sources/aros-ports/gcc-6.5.0.tar.xz
  - sources/aros-ports/gmp-6.3.0.tar.bz2
  - sources/aros-ports/isl-0.25.tar.bz2
  - sources/aros-ports/mpc-1.4.1.tar.xz
  - sources/aros-ports/mpfr-4.2.2.tar.bz2
provides:
  - docker:builder/compiler/aros/2026-08-21/aarch64
---

# AROS 2026-08-21 Raspberry Pi AArch64 Cross-Compiler

AROS's AArch64 GCC and binutils cross-toolchain with the Developer tree for
the Raspberry Pi native target.
