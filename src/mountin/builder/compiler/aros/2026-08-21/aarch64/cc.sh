#!/bin/sh
exec /opt/aros-toolchain/aarch64-aros-gcc --sysroot="$AROS_SYSROOT" "$@"
