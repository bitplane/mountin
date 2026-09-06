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

The patches are arranged beneath `upstream-prs` as six proposed, cumulative
review areas:

1. x86 assembler and expression correctness
2. AOT generation and TempleOS output
3. compiler intrinsics
4. function, interrupt and exception ABI compatibility
5. host source environment
6. source-language, binary-loader and image correctness

The number is the stacking order, not merely presentation: later areas are
reviewed against the preceding ones. Subdirectories separate concerns within
an area, while individual patch files remain commit-sized. AOT expression
handling, symbol resolution and relocation generation are one area because
they share data structures and invariants; splitting them into nominally
independent PRs would conceal those dependencies. Import aliases remain with
symbol resolution rather than the output signature.

The x86-only intrinsics fail compilation explicitly on other targets. The
remaining TempleOS intrinsics not used by the compiler or kernel
(`Carry`, integer square/sign/absolute, and `ClFlush`)
are not yet translated. Interrupt functions follow TempleOS and do not save
XMM state; handlers must not use floating-point values until that restriction
is removed.

The former x86 stack-padding change masked an out-of-bounds write in
`PrsArrayDims`: `&dim` was treated as a `CArrayDim`, so updating `total_cnt`
wrote beyond the pointer parameter into its caller. The source now starts the
walk at `dim`, and no compiler ABI padding is required.

## Validation

Graphical boot uses QEMU TCG, `-cpu max`, one CPU and 512 MiB RAM. After fixing
the `StrLen` register collision and the reversed byte-load encoding, the rebuilt
image completed three cold boots without the earlier heap checks or diagnostic
windows: one was observed for 120 seconds and two for 75 seconds. All reached
the graphical installer prompt and remained responsive. Neither older physical
CPUs nor non-x86 compiler backends have been validated.

## Regression checks

The owning patches add standalone HolyC checks under `Tests/Compiler`:

- `ModU64.HC`: constant and function-call divisors, including unsigned values
  above the signed range.
- `Queues.HC`: insert, reverse insert and remove, with function-call operands.
- `StrLen.HC`: function-call operands and a pointer explicitly assigned to RDX,
  including an empty string.
- `Swap.HC`: 8-, 16-, 32- and 64-bit swaps.
- `X86Opcodes.HC`: direct assembler byte checks for corrected opcode-table
  entries, without AOT or execution of privileged instructions.
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
