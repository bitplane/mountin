#!/bin/sh
set -eu

tree=$MOUNTIN_CACHE_DIR/tree
templeos_source=/opt/templeos/source
output=/host/build/guest/x86_64-templeos/5.03/templeos.iso

if [ ! -d "$tree" ]; then
    cp -a /opt/aiwnios/source "$tree"
fi

# AIWNIOS-generated kernel code uses SSE. Enable OSFXSR and OSXMMEXCPT where
# TempleOS enables the other required CR4 features.
grep -q '^[[:space:]]*OR[[:space:]]*EAX,0xB0$' \
    "$templeos_source/Kernel/KStart64.HC"
sed -i '/^[[:space:]]*OR[[:space:]]*EAX,0xB0$/s/0xB0$/0x6B0/' \
    "$templeos_source/Kernel/KStart64.HC"

cp /build/build-distro.HC "$tree/MountinBuildDistro.HC"
cp /build/build-compiler.HC "$tree/MountinBuildCompiler.HC"
cp /build/build-image.HC "$tree/MountinBuildImage.HC"
cp /build/build-kernel.HC "$tree/MountinBuildKernel.HC"
cp /build/kernel-config.HC "$tree/MountinKernelConfig.HC"
cp /build/kernel-source.HC "$tree/MountinKernelSource.HC"
cp /build/package-distro.HC "$tree/MountinPackageDistro.HC"
cd "$tree"
bootstrap_log=$tree/MountinBootstrap.log
SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy \
    aiwnios -F -d -a -t "$tree" -U "$templeos_source" \
        -c MountinBuildDistro.HC | tee "$bootstrap_log"
grep -q '^MOUNTIN: TempleOS compiler built$' "$bootstrap_log"
rm "$bootstrap_log"

image_log=$tree/MountinImage.log
SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy \
    aiwnios -F -d -a -t "$tree" -U "$templeos_source" \
        -c MountinBuildImage.HC | tee "$image_log"
grep -q '^MOUNTIN: TempleOS kernel built$' "$image_log"
grep -q '^MOUNTIN: RedSea data blocks ' "$image_log"
rm "$image_log"

mkdir -p "$(dirname "$output")"
cp "$tree/Tmp/MyDistro.ISO.C" "$output"
cp "$tree/0000Boot/0000Kernel.BIN.C" "${output%/*}/kernel.bin"
