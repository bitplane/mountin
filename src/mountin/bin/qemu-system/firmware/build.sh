#!/bin/sh
set -eu

SOURCE=/host/build/sources/qemu-10.2.3.tar.gz
OUTPUT_DIR=/host/build/bin/qemu-system/firmware

mkdir -p "$OUTPUT_DIR"
for firmware in "$@"; do
    filename=${firmware##*/}
    tar -xOf "$SOURCE" --wildcards "*/pc-bios/$filename" \
        > "$OUTPUT_DIR/$filename.tmp"
    mv "$OUTPUT_DIR/$filename.tmp" "$OUTPUT_DIR/$filename"
done
