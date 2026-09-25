---
title: AROS 2026-09-24 Raspberry Pi AArch64 Cross-Compiler
env:
  MOUNTIN_BUILDER: builder/compiler/aros
execution_env:
  MOUNTIN_BUILD_JOBS: ${MOUNTIN_BUILD_JOBS}
requires:
  - docker:${MOUNTIN_BUILDER}
build_requires:
  - sources/aros-2026-09-24.tar.gz
  - sources/aros-ports/acpica-unix-20260408.tar.gz
  - sources/aros-ports/boost_1_89_0.tar.gz
  - sources/aros-ports/bzip2-1.0.8.tar.gz
  - sources/aros-ports/codesets/6.22.tar.gz
  - sources/aros-ports/expat-2.8.2.tar.bz2
  - sources/aros-ports/freetype-2.14.3.tar.xz
  - sources/aros-ports/glu-9.0.2.tar.xz
  - sources/aros-ports/grub-2.12.tar.gz
  - sources/aros-ports/jpegsrc.v9f.tar.gz
  - sources/aros-ports/libpng-1.6.58.tar.gz
  - sources/aros-ports/mbedtls-3.6.7.tar.bz2
  - sources/aros-ports/mesa-26.0.0.tar.xz
  - sources/aros-ports/pixman-0.46.4.tar.gz
  - sources/aros-ports/openal-soft-1.19.1.tar.bz2
  - sources/aros-ports/tiff-4.7.2.tar.xz
  - sources/aros-ports/utf8proc/v2.11.3.tar.gz
  - sources/aros-ports/xz-5.8.3.tar.gz
  - sources/aros-ports/zlib.tar.gz
  - sources/aros-ports/zstd-1.5.7.tar.gz
  - sources/aros-ports/rustc-1.98.1-src.tar.xz
  - sources/aros-ports/rustc-1.98.1-${MOUNTIN_BUILD_ARCH}-unknown-linux-gnu.tar.xz
  - sources/aros-ports/rust-std-1.98.1-${MOUNTIN_BUILD_ARCH}-unknown-linux-gnu.tar.xz
  - sources/aros-ports/cargo-1.98.1-${MOUNTIN_BUILD_ARCH}-unknown-linux-gnu.tar.xz
  - sources/aros-ports/binutils-2.47.tar.bz2
  - sources/aros-ports/gcc-16.2.0.tar.xz
  - sources/aros-ports/gmp-6.3.0.tar.bz2
  - sources/aros-ports/isl-0.27.tar.bz2
  - sources/aros-ports/mpc-1.4.1.tar.xz
  - sources/aros-ports/mpfr-4.2.2.tar.bz2
  - sources/aros-ports/UnicodeData.txt
  - sources/aros-ports/SpecialCasing.txt
  - sources/aros-ports/pci.ids
  - sources/linux-6.12.tar.xz
provides:
  - docker:builder/compiler/aros/2026-09-24/aarch64
---

# AROS 2026-09-24 Raspberry Pi AArch64 Cross-Compiler

AROS's AArch64 GCC and binutils cross-toolchain with the Developer tree for
the Raspberry Pi native target.
