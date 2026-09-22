#!/bin/sh
set -eu

output=/host/build/$1
fat=/host/build/data/fs/basic.dosfs-fat12
start=2048
sectors=$(( $(stat -c %s "$fat") / 512 ))
total=$(( start + sectors + 2048 ))

mkdir -p "$(dirname "$output")"
truncate -s $(( total * 512 )) "$output"
sfdisk "$output" <<EOF
label: dos
start=$start, size=$sectors, type=1, bootable
EOF
dd if="$fat" of="$output" bs=512 seek=$start conv=notrunc status=none
dd if="$output" bs=512 skip=$start count=$sectors status=none | cmp - "$fat"
