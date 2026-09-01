#!/bin/sh
set -eu

tree=/opt/aiwnios/source

rm -rf "$tree/MountinFixture"
mkdir -p "$tree/MountinFixture"
tar -xf /host/build/data/templates/basic.tar \
    -C "$tree/MountinFixture" --strip-components=1
cp /build/fixture.HC "$tree/MountinFixture.HC"

cd "$tree"
SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy \
    aiwnios -F -d -t "$tree" -c MountinFixture.HC

test -s "$tree/basic.redsea"
cp "$tree/basic.redsea" /host/build/data/fs/basic.redsea
