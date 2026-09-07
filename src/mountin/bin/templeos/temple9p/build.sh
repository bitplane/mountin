#!/bin/sh
set -eu

tree=$MOUNTIN_CACHE_DIR/tree
source=/host/build/sources/temple9p-0.1.0.tar.xz
output=/host/build/bin/${MOUNTIN_TARGET_PLATFORM}/temple9p

if [ ! -d "$tree" ]; then
    cp -a /opt/mountin/build "$tree"
fi

tar -xf "$source" -C "$tree" --strip-components=1 \
    temple9p-0.1.0/Temple9P.HC temple9p-0.1.0/Serial.HC
cp /build/check.HC "$tree/MountinCheckTemple9P.HC"
cd "$tree"
SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy \
    aiwnios -F -d -t "$tree" -c MountinCheckTemple9P.HC |
    grep -q '^MOUNTIN: temple9p compiled$'

mkdir -p "$output"
cp "$tree/Temple9P.HC" "$tree/Serial.HC" "$output/"
