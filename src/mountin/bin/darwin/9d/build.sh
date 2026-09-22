#!/bin/sh
set -eu

SOURCE=/work/9d
OBJECTS=/work/objects
OUTPUT_DIR=/host/build/bin/${MOUNTIN_TARGET_ARCH}-darwin

rm -rf "$SOURCE" "$OBJECTS"
mkdir -p "$SOURCE" "$OBJECTS" "$OUTPUT_DIR"
tar -xf /host/build/sources/9d-0.8.2.tar.xz \
    -C "$SOURCE" --strip-components=1

(cd "$SOURCE" && ./scripts/release-binary.sh "${MOUNTIN_TARGET_ARCH}-darwin")

"$OBJDUMP" --macho --private-headers "$SOURCE/build/9d" \
    | grep -Eq 'LC_(BUILD_VERSION|VERSION_MIN_MACOSX)'
install -m 755 "$SOURCE/build/9d" "$OUTPUT_DIR/9d"

"$CC" -Os -g0 -Wl,-dead_strip -o "$OBJECTS/stream64" \
    /stream64.c
"$STRIP" -S "$OBJECTS/stream64"
install -m 755 "$OBJECTS/stream64" "$OUTPUT_DIR/stream64"
