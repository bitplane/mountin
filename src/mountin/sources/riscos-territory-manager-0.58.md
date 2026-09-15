---
title: RISC OS TerritoryManager 0.58
version: "0.58"
urls:
  - git+https://github.com/bitplane/TerritoryManager.git#mountin-2026-09-15
provides:
  - sources/riscos-territory-manager-0.58.tar.gz
---

# RISC OS TerritoryManager 0.58

The last assembly implementation of TerritoryManager, used by the headless
cross-built appliance because the subsequent C rewrite requires the newer
SharedCLibrary module-linking toolchain.

The fork is based on upstream `TerritoryManager-0_58` and adds an explicit
`EMBEDDED_UI=yes` build option; its default sprite-based UI is unchanged.
