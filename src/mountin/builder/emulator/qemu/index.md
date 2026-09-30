---
title: Shared QEMU Runtime
build_platforms:
  x86_64-linux: {}
  aarch64-linux: {}
build_requires:
  - bin/qemu-system/${MOUNTIN_BUILD_ARCH}-linux-musl/qemu-system-x86_64
  - bin/qemu-system/${MOUNTIN_BUILD_ARCH}-linux-musl/qemu-system-aarch64
  - bin/qemu-system/${MOUNTIN_BUILD_ARCH}-linux-musl/qemu-system-arm
  - bin/qemu-system/${MOUNTIN_BUILD_ARCH}-linux-musl/qemu-system-m68k
  - bin/qemu-system/${MOUNTIN_BUILD_ARCH}-linux-musl/qemu-img
  - bin/qemu-system/firmware/bios-256k.bin
  - bin/qemu-system/firmware/linuxboot_dma.bin
  - bin/qemu-system/firmware/efi-e1000.rom
  - bin/qemu-system/firmware/efi-e1000e.rom
  - bin/qemu-system/firmware/efi-virtio.rom
  - bin/qemu-system/firmware/vgabios-stdvga.bin
  - bin/qemu-system/firmware/kvmvapic.bin
provides:
  - docker:builder/emulator/qemu
---

# Shared QEMU Runtime

The native system emulators, image utility and PC firmware built from the
single pinned QEMU release. Consumers copy the needed executables and the
firmware directory from this image into their own build environments.
Executables are installed under `/usr/bin` and firmware under `/usr/share/qemu`,
matching the provider's configured installation prefix.
