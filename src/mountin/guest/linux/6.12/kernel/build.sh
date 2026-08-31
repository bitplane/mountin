#!/bin/sh
set -eu

CACHE_DIR=$MOUNTIN_CACHE_DIR
SOURCE_DIR=$CACHE_DIR/source

if [ ! -d "$SOURCE_DIR" ]; then
    temporary=$CACHE_DIR/source.tmp.$$
    rm -rf "$temporary"
    trap 'rm -rf "$temporary"' EXIT HUP INT TERM
    cp -a /opt/mountin/source "$temporary"
    mv "$temporary" "$SOURCE_DIR"
    trap - EXIT HUP INT TERM
fi

cd "$SOURCE_DIR"

# Copy config files
cp /kernel.config /filesystems.config .

# Determine kernel arch
KERNEL_ARCH=$MOUNTIN_TARGET_ARCH
[ "$MOUNTIN_TARGET_ARCH" = "aarch64" ] && KERNEL_ARCH=arm64
if [ "$MOUNTIN_TARGET_ARCH" = "x86_64" ]; then
    KERNEL_TARGET=bzImage
    KERNEL_IMAGE=arch/x86_64/boot/bzImage
elif [ "$MOUNTIN_TARGET_ARCH" = "aarch64" ]; then
    KERNEL_TARGET=Image.gz
    KERNEL_IMAGE=arch/arm64/boot/Image.gz
else
    echo "Unsupported architecture: $MOUNTIN_TARGET_ARCH"
    exit 1
fi

# Build kernel
make ARCH="$KERNEL_ARCH" CROSS_COMPILE="$CROSS_COMPILE" HOSTCC=cc defconfig
./scripts/kconfig/merge_config.sh -m .config kernel.config filesystems.config
yes "" | make ARCH="$KERNEL_ARCH" CROSS_COMPILE="$CROSS_COMPILE" \
    HOSTCC=cc oldconfig
make ARCH="$KERNEL_ARCH" CROSS_COMPILE="$CROSS_COMPILE" HOSTCC=cc \
    -j"${MOUNTIN_BUILD_JOBS}" "$KERNEL_TARGET"

# Copy kernel image
mkdir -p /host/build/guest/${MOUNTIN_TARGET_ARCH}-linux/6.12
cp -v "$KERNEL_IMAGE" \
    /host/build/guest/${MOUNTIN_TARGET_ARCH}-linux/6.12/kernel
