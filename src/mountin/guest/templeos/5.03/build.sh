#!/bin/sh
set -eu

tree=$MOUNTIN_CACHE_DIR/tree
templeos_source=/opt/mountin/source
output=/host/build/guest/x86_64-templeos/5.03/templeos.iso
fixture_output=/host/build/guest/x86_64-templeos/5.03/fixture/templeos.iso

if [ ! -d "$tree" ]; then
    cp -a /opt/mountin/build "$tree"
fi

cp /build/build-distro.HC "$tree/MountinBuildDistro.HC"
cp /build/build-compiler.HC "$tree/MountinBuildCompiler.HC"
cp /build/build-image.HC "$tree/MountinBuildImage.HC"
cp /build/build-kernel.HC "$tree/MountinBuildKernel.HC"
cp /build/fixture-image.HC "$tree/MountinBuildFixtureImage.HC"
cp /build/fixture-once.HC "$tree/MountinFixtureOnce.HC"
cp /build/kernel-config.HC "$tree/MountinKernelConfig.HC"
cp /build/kernel-source.HC "$tree/MountinKernelSource.HC"
cp /build/mountin-appliance.HC "$tree/MountinAppliance.HC"
cp /build/mountin-once.HC "$tree/Once.HC"
cp /build/package-distro.HC "$tree/MountinPackageDistro.HC"
cp /host/build/bin/x86_64-templeos/temple9p/Temple9P.HC "$tree/Temple9P.HC"
cp /host/build/bin/x86_64-templeos/temple9p/Serial.HC "$tree/Serial.HC"
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

rm -rf "$tree/MountinFixtureData"
mkdir -p "$tree/MountinFixtureData"
tar -xf /host/build/data/templates/basic.tar \
    -C "$tree/MountinFixtureData" --strip-components=1
fixture_log=$tree/MountinFixtureImage.log
SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy \
    aiwnios -F -d -t "$tree" -c MountinBuildFixtureImage.HC |
    tee "$fixture_log"
grep -q '^MOUNTIN: fixture boot image complete$' "$fixture_log"
rm "$fixture_log"
mkdir -p "${fixture_output%/*}"
cp "$tree/Tmp/MountinFixture.ISO.C" "$fixture_output"
truncate -s %2048 "$fixture_output"
