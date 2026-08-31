---
title: 9front Compiler Bootstrap
build_platforms:
  x86_64-linux: {}
  aarch64-linux: {}
provides:
  - docker:builder/compiler/9front
---

# 9front Compiler Bootstrap

Internal Linux host tools for running 9front's native, self-hosted compiler
inside QEMU. Versioned descendants add the stage-0 system and source tree.
