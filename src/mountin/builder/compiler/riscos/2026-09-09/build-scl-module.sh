#!/bin/bash
set -eu

scl_source=/opt/mountin/sources/gccsdk/srcdir/gcc/libunixlib
build=/opt/mountin/build/scl-module
prefix=/opt/mountin/scl-module

mkdir -p "$build" "$prefix"
cd "$build"
CC='arm-unknown-riscos-gcc -mmodule' "$scl_source/configure" \
    --host=arm-unknown-riscos \
    --build="$(/usr/share/misc/config.guess)" \
    --target=arm-unknown-riscos \
    --disable-shared \
    --prefix="$prefix"
make -j"${MOUNTIN_BUILD_JOBS:-1}"
make install
