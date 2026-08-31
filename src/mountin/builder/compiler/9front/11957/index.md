---
title: 9front 11957 Build Toolbox
build_platforms:
  x86_64-linux: {}
  aarch64-linux: {}
requires:
  - docker:builder/compiler/9front
build_requires:
  - sources/9front-11957.amd64.qcow2.gz
  - sources/9front-11957.tar.gz
provides:
  - docker:builder/compiler/9front/11957
---

# 9front 11957 Build Toolbox

The extracted 9front 11957 source and its declared amd64 stage-0 compiler
environment. The same native toolchain builds amd64 and ARM64 targets under
QEMU, so this toolbox is deliberately multi-target rather than duplicated by
target architecture.

`9front-build` runs an rc build script against a caller-provided source tree.
The script sees that tree at `/n/src`, writes result files beneath `/n/out`,
and inherits `objtype=amd64` or `objtype=arm64` from `--target`.
