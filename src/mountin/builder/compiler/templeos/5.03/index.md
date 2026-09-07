---
title: TempleOS 5.03 Toolbox
build_platforms:
  x86_64-linux: {}
requires:
  - docker:builder/compiler/aiwnios/2026-02-02
build_requires:
  - sources/templeos-5.03.tar.gz
provides:
  - docker:builder/compiler/templeos/5.03
---

# TempleOS 5.03 Toolbox

The final TempleOS source snapshot, a source-built HolyC bootstrap and the
prepared runtime tree needed to compile TempleOS CBin modules. The toolbox
deliberately retains source rather than importing an installed disk or prebuilt
TempleOS compiler image.

The standard toolbox views expose the patched TempleOS tree as
`/opt/mountin/source`, the AIWNIOS tree beneath `/opt/mountin/sources`, and their
merged, ready-to-run compiler tree as `/opt/mountin/build`. Caller source and
outputs belong in `/work`; the image needs neither network access nor a Mountin
build-directory mount after it has been built.

The source carries two targeted corrections. `PrsArrayDims` starts its
dimension-list walk at the supplied `CArrayDim` rather than treating the
address of the pointer parameter as a dimension node. The long-mode startup
enables CR4.OSFXSR and CR4.OSXMMEXCPT because the bootstrap compiler emits SSE
floating-point instructions.

The bootstrap runtime comes from AIWNIOS. It builds `/Compiler/Compiler` first;
that compiler then builds `/Kernel/Kernel` before TempleOS's own `BootDVDIns`
machinery constructs the distribution image.
