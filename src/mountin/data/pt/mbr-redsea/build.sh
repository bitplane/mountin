#!/bin/sh
set -eu

iso=/host/build/guest/x86_64-templeos/5.03/fixture/templeos.iso
output=/host/build/data/pt/templeos-redsea.mbr

mkdir -p "${output%/*}"
truncate -s 64M "$output"
sfdisk "$output" < /build/partition.sfdisk

python3 /build/verify.py "$iso" "$output"
