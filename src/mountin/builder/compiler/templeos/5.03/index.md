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

The final TempleOS source snapshot and a source-built HolyC bootstrap. The
toolbox deliberately retains source rather than importing an installed disk or
prebuilt TempleOS compiler image.

The bootstrap runtime comes from AIWNIOS. It builds `/Compiler/Compiler` first;
that compiler then builds `/Kernel/Kernel` before TempleOS's own `BootDVDIns`
machinery constructs the distribution image.
