#!/bin/sh
set -eu

NINED_SOURCE=/work/9d-source
OUTPUT_DIR=/host/build/bin/${MOUNTIN_TARGET_ARCH}-aros

rm -rf "$NINED_SOURCE"
mkdir -p "$NINED_SOURCE" "$OUTPUT_DIR"
tar -xf /host/build/sources/9d-0.8.2.tar.xz \
    -C "$NINED_SOURCE" --strip-components=1

(cd "$NINED_SOURCE" && ./scripts/release-binary.sh "${MOUNTIN_TARGET_ARCH}-aros")

cp "$NINED_SOURCE/build/9d" "$OUTPUT_DIR/9d"
