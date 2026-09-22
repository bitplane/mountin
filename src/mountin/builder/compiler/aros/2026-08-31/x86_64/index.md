---
title: AROS 2026-08-31 PC x86_64 Cross-Compiler
env:
  MOUNTIN_BUILDER: builder/compiler/aros
execution_env:
  MOUNTIN_BUILD_JOBS: ${MOUNTIN_BUILD_JOBS}
requires:
  - docker:${MOUNTIN_BUILDER}
build_requires:
  - sources/aros-2026-08-31.tar.gz
  - sources/aros-ports/binutils-2.32.tar.bz2
  - sources/aros-ports/gcc-10.5.0.tar.xz
  - sources/aros-ports/gmp-6.3.0.tar.bz2
  - sources/aros-ports/isl-0.25.tar.bz2
  - sources/aros-ports/mpc-1.4.1.tar.xz
  - sources/aros-ports/mpfr-4.2.2.tar.bz2
  - sources/aros-ports/UnicodeData.txt
  - sources/aros-ports/SpecialCasing.txt
  - sources/aros-ports/acpica-unix-20260408.tar.gz
  - sources/aros-ports/boost_1_89_0.tar.gz
  - sources/aros-ports/bzip2-1.0.8.tar.gz
  - sources/aros-ports/codesets/6.22.tar.gz
  - sources/aros-ports/expat-2.8.2.tar.bz2
  - sources/aros-ports/freetype-2.14.3.tar.xz
  - sources/aros-ports/glu-9.0.2.tar.xz
  - sources/aros-ports/isl-0.27.tar.bz2
  - sources/aros-ports/jpegsrc.v9f.tar.gz
  - sources/aros-ports/libpng-1.6.58.tar.gz
  - sources/aros-ports/mbedtls-3.6.7.tar.bz2
  - sources/aros-ports/mesa-20.0.8.tar.xz
  - sources/aros-ports/tiff-4.7.2.tar.xz
  - sources/aros-ports/utf8proc/v2.11.3.tar.gz
  - sources/aros-ports/xz-5.8.3.tar.gz
  - sources/aros-ports/zlib.tar.gz
  - sources/aros-ports/zstd-1.5.7.tar.gz
provides:
  - docker:builder/compiler/aros/2026-08-31/x86_64
---

# AROS 2026-08-31 PC x86_64 Cross-Compiler

AROS's x86_64 GCC and binutils cross-toolchain and matching Developer tree for
64-bit PC guests. The image contains the source tree, prepared build tree,
toolchain, and sysroot for this AROS source checkpoint.

Consumers inherit `CC`, `AR`, `STRIP`, and `AROS_SYSROOT`. The compiler wrapper
supplies the matching Developer tree as its sysroot.
