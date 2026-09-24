---
title: AROS 2026-08-31 Amiga m68k Cross-Compiler
env:
  MOUNTIN_BUILDER: builder/compiler/aros
execution_env:
  MOUNTIN_BUILD_JOBS: ${MOUNTIN_BUILD_JOBS}
requires:
  - docker:${MOUNTIN_BUILDER}
build_requires:
  - sources/aros-2026-08-31.tar.gz
  - sources/aros-ports/binutils-2.32.tar.bz2
  - sources/aros-ports/gcc-6.5.0.tar.xz
  - sources/aros-ports/gmp-6.3.0.tar.bz2
  - sources/aros-ports/isl-0.25.tar.bz2
  - sources/aros-ports/mpc-1.4.1.tar.xz
  - sources/aros-ports/mpfr-4.2.2.tar.bz2
  - sources/aros-ports/UnicodeData.txt
  - sources/aros-ports/SpecialCasing.txt
provides:
  - docker:builder/compiler/aros/2026-08-31/m68k
---

# AROS 2026-08-31 Amiga m68k Cross-Compiler

AROS's GCC 6.5.0 and binutils 2.32 cross-toolchain and matching Developer tree
for Amiga m68k. The image contains the source tree, prepared build tree,
toolchain, and sysroot for this AROS source checkpoint.

Consumers inherit `CC`, `AR`, `STRIP`, and `AROS_SYSROOT`. The compiler wrapper
supplies the matching Developer tree as its sysroot, so ordinary build systems
do not need to know the AROS toolchain or SDK layout.

The release workflow publishes the image at
`ghcr.io/bitplane/mountin/builder/compiler/aros/2026-08-31/m68k:<release>`.
It runs on Linux hosts and produces Amiga m68k binaries. For example, after
pulling a release image, mount a project at `/work` and use `aros-cc` or the
`CC` environment variable to build it. The image also exposes `aros-ar` and
`aros-strip` and includes the matching AROS source and Developer tree.
