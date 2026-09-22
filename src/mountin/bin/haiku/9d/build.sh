#!/bin/sh
set -eu

NINED_SOURCE=/work/9d
OUTPUT_DIR=/host/build/bin/${MOUNTIN_TARGET_ARCH}-haiku

rm -rf "$NINED_SOURCE"
mkdir -p "$NINED_SOURCE" "$OUTPUT_DIR"

tar -xf /host/build/sources/9d-0.8.2.tar.xz \
    -C "$NINED_SOURCE" --strip-components=1

(cd "$NINED_SOURCE" && ./scripts/release-binary.sh "${MOUNTIN_TARGET_ARCH}-haiku")

case "$MOUNTIN_TARGET_ARCH" in
    x86_64) elf_machine="Advanced Micro Devices X86-64" ;;
    aarch64) elf_machine="AArch64" ;;
    *)
        echo "Unsupported Haiku architecture: $MOUNTIN_TARGET_ARCH" >&2
        exit 1
        ;;
esac
"$READELF" -h "$NINED_SOURCE/build/9d" | grep -q "Machine:.*$elf_machine"
"$READELF" -d "$NINED_SOURCE/build/9d" \
    | grep -q "Shared library: \\[libroot.so\\]"
"$READELF" -d "$NINED_SOURCE/build/9d" \
    | grep -q "Shared library: \\[libnetwork.so\\]"

install -m 755 "$NINED_SOURCE/build/9d" \
    "$OUTPUT_DIR/9d"
