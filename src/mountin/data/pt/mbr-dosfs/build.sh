#!/bin/sh
set -eu

temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT

for target do
    output=/host/build/$target
    case "$target" in
        */basic-fat16-fat32.mbr|*/basic-fat-extended.mbr)
            for kind in fat12 fat16 fat32; do
                source=/host/build/data/fs/basic.$kind
                if [ "$kind" = fat12 ]; then
                    source=/host/build/data/fs/basic.dosfs-fat12
                fi
                cp "$source" "$temporary/$kind.img"
                printf '%s partition\n' "$(printf '%s' "$kind" | tr '[:lower:]' '[:upper:]')" > "$temporary/marker"
                mcopy -o -i "$temporary/$kind.img" "$temporary/marker" ::PART.TXT
            done
            first=2048
            first_sectors=$(( $(stat -c %s "$temporary/fat16.img") / 512 ))
            second=$(( ((first + first_sectors + 2047) / 2048) * 2048 ))
            fat12_sectors=$(( $(stat -c %s "$temporary/fat12.img") / 512 ))
            fat32_sectors=$(( $(stat -c %s "$temporary/fat32.img") / 512 ))
            mkdir -p "$(dirname "$output")"
            case "$target" in
                */basic-fat-extended.mbr)
                    logical_first=$(( second + 2048 ))
                    logical_second=$(( ((logical_first + fat12_sectors + 2047) / 2048) * 2048 + 2048 ))
                    end=$(( logical_second + fat32_sectors ))
                    truncate -s $(( (end + 2048) * 512 )) "$output"
                    sfdisk "$output" <<EOF
label: dos
start=$first, size=$first_sectors, type=6
start=$second, size=$(( end - second )), type=f
start=$logical_first, size=$fat12_sectors, type=1
start=$logical_second, size=$fat32_sectors, type=c
EOF
                    dd if="$temporary/fat12.img" of="$output" bs=512 seek=$logical_first conv=notrunc status=none
                    dd if="$temporary/fat32.img" of="$output" bs=512 seek=$logical_second conv=notrunc status=none
                    dd if="$output" bs=512 skip=$logical_first count=$fat12_sectors status=none | cmp - "$temporary/fat12.img"
                    dd if="$output" bs=512 skip=$logical_second count=$fat32_sectors status=none | cmp - "$temporary/fat32.img"
                    ;;
                *)
                    truncate -s $(( (second + fat32_sectors + 2048) * 512 )) "$output"
                    sfdisk "$output" <<EOF
label: dos
start=$first, size=$first_sectors, type=6
start=$second, size=$fat32_sectors, type=c
EOF
                    dd if="$temporary/fat32.img" of="$output" bs=512 seek=$second conv=notrunc status=none
                    dd if="$output" bs=512 skip=$second count=$fat32_sectors status=none | cmp - "$temporary/fat32.img"
                    ;;
            esac
            dd if="$temporary/fat16.img" of="$output" bs=512 seek=$first conv=notrunc status=none
            dd if="$output" bs=512 skip=$first count=$first_sectors status=none | cmp - "$temporary/fat16.img"
            sfdisk --verify "$output"
            continue
            ;;
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
