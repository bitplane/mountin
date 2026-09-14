#!/bin/bash
set -eu

source_dir=/opt/mountin/sources/cmunge

mkdir -p "$source_dir"
tar --no-same-owner -xzf /host/build/sources/riscos-cmunge-0.85.tar.gz \
    -C "$source_dir" --strip-components=1
patch -d "$source_dir" -p1 < /patches/cmunge-gcc.patch

make -C "$source_dir/crosscompile" links
make -C "$source_dir/crosscompile" -j"$MOUNTIN_BUILD_JOBS" \
    CC=/usr/bin/cc \
    'CDEFINES=-DGCC_BIN_DIR=\"/opt/gccsdk/cross/bin/\"'
install -m 755 "$source_dir/crosscompile/riscos-cmunge" /opt/rool/bin/cmunge
ln -s arm-unknown-riscos-gcc /opt/gccsdk/cross/bin/gcc
