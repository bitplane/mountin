---
title: RISC OS BuildHost snapshot 2025-05-17
version: "2025-05-17"
urls:
  - git+https://github.com/bitplane/BuildHost.git#mountin-2026-09-15
provides:
  - sources/riscos-buildhost-2025-05-17.tar.gz
---

# RISC OS BuildHost

The pinned RISC OS Open source product containing the build-system utilities
needed to construct RISC OS on a POSIX host. Its recursively pinned submodules
are included in the source archive.

Based on upstream product commit `90e6e48877a117095f0e3009a2e3ec69edd3227a`,
with the tested CLXLite and srcbuild POSIX fixes selected from their component
forks. All other component revisions are unchanged.
