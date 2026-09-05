---
title: AIWNIOS 2026-02-02 Toolbox
build_platforms:
  x86_64-linux: {}
execution_env:
  MOUNTIN_BUILD_JOBS: "2"
requires:
  - docker:builder/compiler/aiwnios
build_requires:
  - sources/aiwnios-2026-02-02.tar.gz
provides:
  - docker:builder/compiler/aiwnios/2026-02-02
---

# AIWNIOS 2026-02-02 Toolbox

Source-built HolyC compiler and runtime. The C implementation bootstraps its
`HCRT2.BIN` from the accompanying HolyC source; no TempleOS compiler binary is
used as an input.

The toolbox retains the matching source tree because AIWNIOS resolves its
runtime, documentation and build scripts relative to that tree.

## Patch set

The `series` file is the authoritative patch order. Patches are generated from
successive commits against the unmodified 2026-02-02 source and are applied
with zero fuzz, so upstream drift fails the toolbox build instead of silently
moving a hunk.

The current groups provide:

- TempleOS x86 assembler syntax and encoding
- raw TempleOS AOT output, symbols and relocations
- TempleOS binary loading and exception/interrupt ABI support
- compiler intrinsics used by the TempleOS kernel
- host-directory and relative-include source access
- DVD image generation needed by the guest build

The x86-only intrinsics fail compilation explicitly on other targets. The
remaining TempleOS intrinsics not used by the compiler or kernel
(`Carry`, integer square/sign/absolute/swap, `ClFlush`, and unsigned modulo)
are not yet translated. Interrupt functions follow TempleOS and do not save
XMM state; handlers must not use floating-point values until that restriction
is removed.

The x86 backend emits SSE instructions. An explicit compiler output option
enables the corresponding CR4 state at the kernel's CR4 write, allowing an
AIWNIOS-built kernel to retain the unmodified TempleOS source semantics while
meeting the generated code's runtime requirements.
