---
title: QEMU 10.2.3
urls:
  - git+https://github.com/bitplane/qemu.git#mountin-2026-10-01
provides:
  - sources/qemu-10.2.3.tar.gz
---

# QEMU 10.2.3

Full system emulator for multiple architectures. The Mountin release adds the
Raspberry Pi hardware support required to boot RISC OS; its commits remain
separate on the fork's `mountin` branch for upstream submission.

The shared release also refreshes the PL011 character backend when UART FIFO
mode changes. Its complete RISC OS filesystem and native partition gates pass
without request-byte pacing. System emulators and `qemu-img` use this same
source pin; build containers consume those outputs instead of distro QEMU.
