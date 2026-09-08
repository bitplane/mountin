#!/bin/sh
set -eu

source=/work/9d
output=/host/build/bin/${MOUNTIN_TARGET_PLATFORM}/9d

rm -rf "$source"
mkdir -p "$source" "${output%/*}"
tar -xf /host/build/sources/9d-0.7.6.tar.xz \
    -C "$source" --strip-components=1

make -C "$source" release \
    PLATFORM=riscos NETWORK=0 STATIC=1 THREAD_LIBS= \
    API_CPPFLAGS='-D_XOPEN_SOURCE=700 -D_POSIX_C_SOURCE=200809L' \
    RELEASE_CFLAGS='-Os -fno-common -DS9_PATH_MAX=1024'

readelf=arm-unknown-riscos-readelf
"$readelf" -h "$source/build/9d" | grep -q 'Machine:.*ARM'
if "$readelf" -l "$source/build/9d" | grep -q INTERP; then
    echo 'RISC OS 9d unexpectedly has a dynamic interpreter' >&2
    exit 1
fi

cp "$source/build/9d" "$output"
