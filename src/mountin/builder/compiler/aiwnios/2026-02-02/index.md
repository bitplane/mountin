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

The patches are arranged beneath `upstream-prs` as four proposed changes:

1. general compiler correctness
2. x86 assembler correctness
3. host filesystem integration
4. TempleOS support

The first three apply independently to the unmodified upstream source. Each
patch is the formatted form of one proposed commit and contains one fix, class
of related fixes, or complete required feature. TempleOS support is the full
integration change retained by Mountin; it can be submitted after its general
prerequisites have landed. Its AOT expression handling, symbol resolution and
relocation generation remain together because they share data structures and
invariants.

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

The x86 spill-slot fix passes the source-built runtime bootstrap and all nine
compiler regression checks below, including inline current-PC comparisons.
The compiler-correctness group also applies independently with `git am`.

Graphical boot uses QEMU TCG, `-cpu max`, one CPU and 512 MiB RAM. After fixing
the `StrLen` register collision, the rebuilt image completed three cold boots
without the earlier heap checks or diagnostic windows: one was observed for 120
seconds and two for 75 seconds. All reached the graphical installer prompt and
remained responsive. Neither older physical CPUs nor non-x86 compiler backends
have been validated.

## Regression checks

The owning patches add standalone HolyC checks under `Tests/Compiler`:

- `CallCompare.HC`: spilled call results in comparisons and short-circuit
  conditions, including floating-point results and stack-local preservation.
- `CurrentPC.HC`: code addresses returned directly, stored locally and used in
  expressions, with repeated calls. The x86 check passes; AArch64, RISC-V and
  bytecode current-PC implementations have passed syntax checks, not runtime
  validation.
- `ModU64.HC`: constant and function-call divisors, including unsigned values
  above the signed range.
- `Queues.HC`: insert, reverse insert and remove, with function-call operands.
- `StrLen.HC`: function-call operands and a pointer explicitly assigned to RDX,
  including an empty string.
- `Swap.HC`: 8-, 16-, 32- and 64-bit swaps.
- `X86Opcodes.HC`: direct assembler byte checks for corrected opcode-table
  entries, without AOT or execution of privileged instructions.
- `X86Aliases.HC`: direct assembler byte checks for 16/32-bit width aliases,
  both `FSTSW` forms, and a following label.
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
