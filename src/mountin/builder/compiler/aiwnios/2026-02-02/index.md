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

## Fork

The toolbox builds the immutable `mountin-2026-09-07` release from the Mountin
fork. Its changes are maintained as four branches:

- TempleOS x86 assembler syntax and encoding
- raw TempleOS AOT output, symbols and relocations
- TempleOS binary loading and exception/interrupt ABI support
- compiler intrinsics used by the TempleOS kernel
- host-directory and relative-include source access
- DVD image generation needed by the guest build

- [`bugfix/compiler-correctness`](https://github.com/bitplane/Aiwnios/tree/bugfix/compiler-correctness)
- [`bugfix/x86-assembler-correctness`](https://github.com/bitplane/Aiwnios/tree/bugfix/x86-assembler-correctness)
- [`feature/host-filesystem`](https://github.com/bitplane/Aiwnios/tree/feature/host-filesystem)
- [`feature/templeos-support`](https://github.com/bitplane/Aiwnios/tree/feature/templeos-support)

The first three start at the upstream snapshot. TempleOS support starts at their
combined integration point because it uses the compiler and host interfaces
they add. The `mountin` branch merges all four and supplies the release tag.

TempleOS support contains seven feature commits: file-size interfaces,
integer register types, DVD sizing, AOT modules and raw images, exception/
interrupt/variadic ABIs, kernel intrinsics, and debug maps. The consolidated
series produces the same source tree as the incremental patches.

`OPTf_TEMPLEOS` selects the TempleOS x86-64 ABI and module format, including
native segment access, variadic stack arguments, data placement and import
records. It is not just a signature override. `OPTf_RAW_AOT` independently
selects unwrapped output for boot code; the kernel build enables both.

The x86-only intrinsics fail compilation explicitly on other targets. The
remaining TempleOS intrinsics not used by the compiler or kernel
(`Carry`, integer square/sign/absolute, and `ClFlush`)
are not yet translated. Interrupt functions follow TempleOS and do not save
XMM state; handlers must not use floating-point values until that restriction
is removed.

## Validation

The consolidated patch set passes the source-built x86 runtime bootstrap and
all twelve regression checks below. Host-drive registration passes both with
and without `--host-drive`. A separate compile check enables `OPTf_TEMPLEOS`
and verifies the emitted module signature.

The compiler-correctness group also rejects missing or incomplete native
module headers before allocating a code heap. Startup without `HCRT2.BIN`
reports the missing runtime and exits with status 1; source bootstrap and all
twelve runtime checks pass after this change. This checks header presence,
not the contents of every relocation record.

The compiler-correctness, x86-assembler and host-filesystem branches each
bootstrap independently. Their combined source plus TempleOS support produces
the tagged source tree used here.

The earlier graphical boot checks used QEMU TCG, `-cpu max`, one CPU and 512 MiB
RAM; they have not been repeated after consolidation. After fixing
the `StrLen` register collision, the rebuilt image completed three cold boots
without the earlier heap checks or diagnostic windows: one was observed for 120
seconds and two for 75 seconds. All reached the graphical installer prompt and
remained responsive. Older physical x86 CPUs have not been validated.

The complete series also builds and bootstraps `HCRT2.BIN` natively on
AArch64. `FileSize`, `HostDrives`, `IncludeSearch`, `CallCompare`, and
`CurrentPC` pass there in separate processes. The remaining regression checks
exercise x86 instructions or intrinsics whose lowering is explicitly absent
from the AArch64 backend.

The complete series also cross-compiles and bootstraps `HCRT2.BIN` under a full
RISC-V Linux VM. `FileSize`, `HostDrives`, `IncludeSearch`, `CallCompare`, and
`CurrentPC` pass there in separate processes. As on AArch64, the remaining
regression checks exercise x86 instructions or intrinsics whose lowering is
explicitly absent from the RISC-V backend.

## Regression checks

The owning patches add standalone HolyC checks under `Tests/Compiler`:

- `FileSize.HC`: open-file and pathname sizes agree; a null file handle returns
  zero.
- `HostDrives.HC`: registered drives match mounted host drives, with and without
  the optional U drive.
- `IncludeSearch.HC`: current-directory precedence and source-relative fallback,
  including nested includes and parent paths.
- `CallCompare.HC`: spilled call results in comparisons and short-circuit
  conditions, including floating-point results and stack-local preservation.
- `CurrentPC.HC`: code addresses returned directly, stored locally and used in
  expressions, with repeated calls. The x86, AArch64, and RISC-V checks pass;
  the bytecode implementation has passed syntax checks, not runtime validation.
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
