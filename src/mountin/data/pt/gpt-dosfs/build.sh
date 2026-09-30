#!/bin/sh
set -eu

output=/host/build/$1
mkdir -p "$(dirname "$output")"
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT

first=2048
for kind in fat16 fat32; do
    image=$temporary/$kind.img
    cp /host/build/data/fs/basic.$kind "$image"
    printf '%s partition\n' "$(printf '%s' "$kind" | tr '[:lower:]' '[:upper:]')" > "$temporary/marker"
    mcopy -o -i "$image" "$temporary/marker" ::PART.TXT
done
first_sectors=$(( $(stat -c %s "$temporary/fat16.img") / 512 ))
second=$(( ((first + first_sectors + 2047) / 2048) * 2048 ))
second_sectors=$(( $(stat -c %s "$temporary/fat32.img") / 512 ))
total=$(( second + second_sectors + 2048 ))

truncate -s $(( total * 512 )) "$output"
sfdisk "$output" <<EOF
label: gpt
start=$first, size=$first_sectors, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, name=fat16
start=$second, size=$second_sectors, type=EBD0A0A2-B9E5-4433-87C0-68B6B72699C7, name=fat32
EOF
dd if="$temporary/fat16.img" of="$output" bs=512 seek=$first conv=notrunc status=none
dd if="$temporary/fat32.img" of="$output" bs=512 seek=$second conv=notrunc status=none
dd if="$output" bs=512 skip=$first count=$first_sectors status=none | cmp - "$temporary/fat16.img"
dd if="$output" bs=512 skip=$second count=$second_sectors status=none | cmp - "$temporary/fat32.img"
sfdisk --verify "$output"
