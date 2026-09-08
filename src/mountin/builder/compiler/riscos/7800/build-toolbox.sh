#!/bin/bash
set -eu

cat >/opt/mountin/source/gccsdk-params <<'EOF'
export GCCSDK_INSTALL_CROSSBIN=/opt/gccsdk/cross/bin
export GCCSDK_INSTALL_ENV=/opt/gccsdk/env
EOF

cd /opt/mountin/source
export GCCSDK_ROOT=$PWD
. ./setup-gccsdk-params
mkdir -p buildstepsdir

make -j"$MOUNTIN_BUILD_JOBS" cross-gcc-built \
    GCCSDK_INTERNAL_GETENV= \
    GCC_LANGUAGES=c \
    GCC_USE_SCM=no \
    GCC_USE_PPL_CLOOG=no \
    GCC_USE_LTO=no \
    CROSS_ENABLE_SHARED=no \
    GCC_CONFIG_ARGS='--enable-threads=posix --enable-sjlj-exceptions=no --enable-c99 --enable-cmath --disable-c-mbchar --disable-wchar_t --disable-libstdcxx-pch --disable-tls --enable-__cxa_atexit --enable-maintainer-mode --disable-werror --enable-interwork --disable-nls --disable-libquadmath --enable-checking=release --disable-multilib'
