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

The `series` file is the authoritative patch order. Patches describe successive
source changes against the unmodified 2026-02-02 source and are applied with
zero fuzz. Offsets are allowed; changed context is not.

The current groups provide:

- TempleOS x86 assembler syntax and encoding
- raw TempleOS AOT output, symbols and relocations
- TempleOS binary loading and exception/interrupt ABI support
- compiler intrinsics used by the TempleOS kernel
- host-directory and relative-include source access
- DVD image generation needed by the guest build

The directories group related changes, not independent PRs. AOT expression
handling, symbol resolution and relocation generation depend on one another;
the assembler's AOT support uses that machinery too. `binary-loader` contains
module-record readers, `source-language` contains type aliases, and
`source-environment` contains only host-file access changes. Import aliases
belong to symbol resolution, independently of the output binary signature.

The x86-only intrinsics fail compilation explicitly on other targets. The
remaining TempleOS intrinsics not used by the compiler or kernel
(`Carry`, integer square/sign/absolute, and `ClFlush`)
are not yet translated. Interrupt functions follow TempleOS and do not save
XMM state; handlers must not use floating-point values until that restriction
is removed.

## Review boundaries

Two policies need further design before upstream submission:

- `runtime-compatibility` changes the emitted CR4 write when
  `OPTf_X86_SSE_RUNTIME` is selected. This enables SSE state for the generated
  kernel, but it is an opt-in bootstrap transformation, not faithful assembly
  of that instruction. Its option declaration lives with its implementation.
- `function-abi/reserve-call-scratch.patch` reserves two stack words in x86
  function frames. Its scope needs a calling-convention test covering hosted,
  AOT and mixed calls before narrowing it or proposing it upstream. The output
  file signature alone does not describe every callee used during bootstrap.

Graphical boot uses QEMU TCG, `-cpu max`, one CPU and 512 MiB RAM. A `StrLen`
emitter bug could clear a string pointer allocated in `RDX`, producing delayed
heap-check failures after the desktop appeared. Three independent boots of the
corrected image remained healthy through their final 55- or 60-second capture;
one was sampled every five seconds through startup. Neither older physical CPUs
nor non-x86 compiler backends have been validated.

## Regression checks

The owning patches add standalone HolyC checks under `Tests/Compiler`:

- `ModU64.HC`: constant and function-call divisors, including unsigned values
  above the signed range.
- `Queues.HC`: insert, reverse insert and remove, with function-call operands.
- `StrLen.HC`: string-length lowering with a function-call operand.
- `X86Aliases.HC`: AOT-only byte checks for 16/32-bit width aliases, both
  `FSTSW` forms, and a following label. It never executes the mixed-mode code.
- `TempleOSMap.HC`: module-relative 32-bit map addresses from 64-bit debug
  entries, sparse lines, invalid line ranges and unrepresentable addresses.

Run each check in a separate process from the built source tree, for example:

```sh
SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy \
    ./aiwnios -F -d -t "$PWD" -c /Tests/Compiler/Queues.HC
```

Require its `PASS:` line: a caught HolyC exception can still leave the process
with a zero exit status. These checks supplement the compiler bootstrap and
fresh TempleOS image build and boot; they do not replace them.
