---
title: RISC OS BCM2835 2026-09-09 Toolbox
build_platforms:
  x86_64-linux: {}
  aarch64-linux: {}
output_platforms:
  arm-riscos:
    provides:
      - docker:builder/compiler/riscos/2026-09-09
requires:
  - docker:builder/compiler/riscos/7800
build_requires:
  - sources/riscos-buildhost-2025-05-17.tar.gz
  - sources/riscos-bcm2835-2026-09-09.tar.gz
  - sources/riscos-decgen-1.41b.zip
  - sources/riscos-cmunge-0.85.tar.gz
  - sources/riscos-territory-manager-0.58.tar.gz
---

# RISC OS BCM2835 2026-09-09 Toolbox

The pinned BCM2835 source product, its pinned BuildHost source product, GCCSDK
r7800, CMunge 0.85, and the POSIX host utilities required to continue the RISC
OS build.

This is the internal environment shared by guest compilation and appliance
assembly. The GCCSDK r7800 toolbox is the application compiler published for
other projects; this image adds the tools and sources for this OS generation.

The toolbox is self-contained and performs no network access. The operating
system source is exposed at `/opt/mountin/source`, the BuildHost sources at
`/opt/mountin/sources/buildhost`, and native build utilities in `/opt/rool/bin`.

The local `resgen` adapter implements the `area output -via file` form used by
the GNU makefiles. It uses GCCSDK's `mkresfs` to encode ResourceFS data and emits
an ARM ELF object exporting the named accessor. It is not the original AOF
ResGen tool or a replacement for its full command-line interface.
