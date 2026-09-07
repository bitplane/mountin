#!/bin/sh
set -eu

source=/host/build/guest/${MOUNTIN_TARGET_PLATFORM}/5.03/templeos.iso
fixture=/host/build/data/fs/basic.redsea
partitioned=/host/build/data/pt/templeos-redsea.mbr
fat32=/host/build/data/pt/templeos-fat32.mbr
output=/host/build/bin/qemu/${MOUNTIN_TARGET_PLATFORM}/5.03/templeos.iso

python3 /build/verify.py "$source" "$fixture"
python3 /build/verify.py "$source" "$partitioned"
python3 /build/verify.py "$source" "$fat32"

mkdir -p "${output%/*}"
cp "$source" "$output"
