#!/bin/sh
set -eu

for target do
    output=/host/build/$target
    case "$target" in
        */basic-fat-multi.mbr)
            fat16=/host/build/data/fs/basic.fat16
            fat12=/host/build/data/fs/basic.dosfs-fat12
            first=2048
            first_sectors=$(( $(stat -c %s "$fat16") / 512 ))
            second=$(( ((first + first_sectors + 2047) / 2048) * 2048 ))
            second_sectors=$(( $(stat -c %s "$fat12") / 512 ))
            total=$(( second + second_sectors + 2048 ))
            mkdir -p "$(dirname "$output")"
            truncate -s $(( total * 512 )) "$output"
            sfdisk "$output" <<EOF
label: dos
start=$first, size=$first_sectors, type=6
start=$second, size=$second_sectors, type=1, bootable
EOF
            dd if="$fat16" of="$output" bs=512 seek=$first conv=notrunc status=none
            dd if="$fat12" of="$output" bs=512 seek=$second conv=notrunc status=none
            dd if="$output" bs=512 skip=$first count=$first_sectors status=none | cmp - "$fat16"
            dd if="$output" bs=512 skip=$second count=$second_sectors status=none | cmp - "$fat12"
            continue
            ;;
        */basic-fat12.mbr)
            fat=/host/build/data/fs/basic.dosfs-fat12
            type=1
            bootable=,bootable
            ;;
        */basic-fat16.mbr)
            fat=/host/build/data/fs/basic.fat16
            type=6
            bootable=
            ;;
        */basic-fat32.mbr)
            fat=/host/build/data/fs/basic.fat32
            type=c
            bootable=
            ;;
        *)
            echo "Unknown DOSFS MBR target: $target" >&2
            exit 1
            ;;
    esac
    start=2048
    sectors=$(( $(stat -c %s "$fat") / 512 ))
    total=$(( start + sectors + 2048 ))

    mkdir -p "$(dirname "$output")"
    truncate -s $(( total * 512 )) "$output"
    sfdisk "$output" <<EOF
label: dos
start=$start, size=$sectors, type=$type$bootable
EOF
    dd if="$fat" of="$output" bs=512 seek=$start conv=notrunc status=none
    dd if="$output" bs=512 skip=$start count=$sectors status=none | cmp - "$fat"
done
