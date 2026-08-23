#!/bin/sh
set -eu

GUEST_DIR=/host/build/guest/aarch64-aros/2026-08-21
OUTPUT_DIR=/host/build/bin/qemu/aarch64-aros/2026-08-21
NINED=/host/build/bin/aarch64-aros/9d
DISK=$OUTPUT_DIR/system.img
PARTITION_OFFSET=1048576

mkdir -p "$OUTPUT_DIR"
cp "$GUEST_DIR/aros-aarch64-raspi.img" "$OUTPUT_DIR/"
cp "$GUEST_DIR/aros-aarch64-bsp.rom" "$OUTPUT_DIR/"
cp "$GUEST_DIR/bcm2837-rpi-3-b.dtb" "$OUTPUT_DIR/"
cp "$GUEST_DIR/config.txt" "$OUTPUT_DIR/"

rm -f "$DISK"
truncate -s 16M "$DISK"
printf 'label: dos\nstart=2048, type=c, bootable\n' | sfdisk "$DISK"
mkfs.vfat -F 32 --offset 2048 -n MOUNTIN "$DISK"
mmd -i "$DISK@@$PARTITION_OFFSET" ::C ::L ::DEVS ::DEVS/DOSDrivers ::S
mcopy -i "$DISK@@$PARTITION_OFFSET" "$NINED" ::C/9d
mcopy -i "$DISK@@$PARTITION_OFFSET" "$GUEST_DIR/rawio-handler" ::L/rawio-handler
printf '%s\n' \
    'Handler = L:rawio-handler' \
    'Priority = 5' \
    'GlobVec = -1' \
    'Startup = 0' \
    | mcopy -i "$DISK@@$PARTITION_OFFSET" - ::DEVS/DOSDrivers/RAWIO
printf 'aarch64\n' | mcopy -i "$DISK@@$PARTITION_OFFSET" - ::AROS.boot
printf '%s\n' \
    'C:FailAt 21' \
    'C:Assign LIBS: SYS:Libs' \
    'C:Automount' \
    'C:Mount DEVS:DOSDrivers/RAWIO' \
    'C:9d -p stream!RAWIO:' \
    | mcopy -i "$DISK@@$PARTITION_OFFSET" - ::S/Startup-Sequence
