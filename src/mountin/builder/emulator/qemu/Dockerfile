FROM alpine:3.23
ARG MOUNTIN_BUILD_ARCH

RUN set -eu; \
    for binary in qemu-system-x86_64 qemu-system-aarch64 qemu-system-arm qemu-system-m68k qemu-img; do \
        install -m 755 /host/build/bin/qemu-system/${MOUNTIN_BUILD_ARCH}-linux-musl/$binary /usr/bin/$binary; \
    done; \
    mkdir -p /usr/share/qemu; \
    for firmware in bios-256k.bin linuxboot_dma.bin efi-e1000.rom efi-e1000e.rom efi-virtio.rom vgabios-stdvga.bin kvmvapic.bin; do \
        install -m 644 /host/build/bin/qemu-system/firmware/$firmware /usr/share/qemu/$firmware; \
    done
