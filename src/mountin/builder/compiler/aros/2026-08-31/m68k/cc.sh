#!/bin/sh
set -eu

exec /opt/aros-toolchain/m68k-aros-gcc \
    --sysroot="${AROS_SYSROOT}" "$@"
