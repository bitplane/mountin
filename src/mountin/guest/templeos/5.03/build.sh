#!/bin/sh
set -eu

tree=/opt/aiwnios/source
templeos_source=/opt/templeos/source
output=/host/build/guest/x86_64-templeos/5.03/templeos.iso

# AIWNIOS-generated kernel code uses SSE. Enable OSFXSR and OSXMMEXCPT where
# TempleOS enables the other required CR4 features.
grep -q '^\tOR\tEAX,0xB0$' "$templeos_source/Kernel/KStart64.HC"
sed -i 's/^\tOR\tEAX,0xB0$/\tOR\tEAX,0x6B0/' \
    "$templeos_source/Kernel/KStart64.HC"

cp /build/build-distro.HC "$tree/MountinBuildDistro.HC"
cp /build/build-compiler.HC "$tree/MountinBuildCompiler.HC"
cp /build/build-kernel.HC "$tree/MountinBuildKernel.HC"
cp /build/build-native.HC "$tree/MountinBuildNative.HC"
cp /build/kernel-config.HC "$tree/MountinKernelConfig.HC"
cp /build/package-distro.HC "$tree/MountinPackageDistro.HC"
cd "$tree"
bootstrap_log=$tree/MountinBootstrap.log
SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy \
    aiwnios -F -d -a -t "$tree" -U "$templeos_source" \
        -c MountinBuildDistro.HC | tee "$bootstrap_log"
grep -q '^MOUNTIN: TempleOS compiler built$' "$bootstrap_log"
rm "$bootstrap_log"

native_log=$tree/MountinNative.log
SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy \
    aiwnios -F -d -a -t "$tree" -U "$templeos_source" \
        -c MountinBuildNative.HC | tee "$native_log"
grep -q '^MOUNTIN: TempleOS compiler loaded$' "$native_log"
grep -q '^MOUNTIN: TempleOS kernel built$' "$native_log"
grep -q '^MOUNTIN: RedSea data blocks ' "$native_log"
rm "$native_log"

mkdir -p "$(dirname "$output")"
cp "$tree/Tmp/MyDistro.ISO.C" "$output"
cp "$tree/0000Boot/0000Kernel.BIN.C" "${output%/*}/kernel.bin"
