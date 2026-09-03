#!/bin/sh
set -eu

source=/host/build/guest/${MOUNTIN_TARGET_PLATFORM}/5.03/templeos.iso
output=/host/build/bin/qemu/${MOUNTIN_TARGET_PLATFORM}/5.03/templeos.iso
mkdir -p "${output%/*}"
cp "$source" "$output"
