#!/bin/sh
set -eu

tree=/opt/aiwnios/source
output=/host/build/guest/x86_64-templeos/5.03/templeos.iso

cp /build/build-distro.HC "$tree/MountinBuildDistro.HC"
SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy \
    aiwnios -F -d -t "$tree" -U /opt/templeos/source \
        -c MountinBuildDistro.HC

mkdir -p "$(dirname "$output")"
cp "$tree/Tmp/MyDistro.ISO.C" "$output"
