#!/bin/sh
set -eu

source=/host/build/guest/${MOUNTIN_TARGET_PLATFORM}/5.03/templeos.iso
fixture=/host/build/data/fs/basic.redsea
output=/host/build/bin/qemu/${MOUNTIN_TARGET_PLATFORM}/5.03/templeos.iso

python3 /build/verify.py "$source" "$fixture"

mkdir -p "${output%/*}"
cp "$source" "$output"
