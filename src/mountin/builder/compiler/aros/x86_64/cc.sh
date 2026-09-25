#!/bin/sh
set -eu

exec /opt/aros-toolchain/x86_64-aros-gcc \
    --sysroot="${AROS_SYSROOT}" "$@"
