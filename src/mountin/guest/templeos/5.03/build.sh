#!/bin/sh
set -eu

tree=/opt/aiwnios/source
output=/host/build/guest/x86_64-templeos/5.03/templeos.iso

cp /build/build-distro.HC "$tree/MountinBuildDistro.HC"
cp /build/build-kernel.HC "$tree/MountinBuildKernel.HC"
cp /build/kernel-config.HC "$tree/MountinKernelConfig.HC"
cp /build/package-distro.HC "$tree/MountinPackageDistro.HC"
cd "$tree"
build_log=$tree/MountinBuild.log
SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy \
    aiwnios -F -d -a -t "$tree" -U /opt/templeos/source \
        -c MountinBuildDistro.HC | tee "$build_log"
grep -q '^MOUNTIN: TempleOS compiler built$' "$build_log"
grep -q '^MOUNTIN: TempleOS kernel built$' "$build_log"
grep -q '^MOUNTIN: RedSea data blocks ' "$build_log"
rm "$build_log"

mkdir -p "$(dirname "$output")"
cp "$tree/Tmp/MyDistro.ISO.C" "$output"
cp "$tree/0000Boot/0000Kernel.BIN.C" "${output%/*}/kernel.bin"
