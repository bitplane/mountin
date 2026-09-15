---
title: CMunge 0.85
version: "0.85"
urls:
  - https://github.com/bitplane/riscos-cmunge/archive/refs/tags/mountin-2026-09-15.tar.gz
provides:
  - sources/riscos-cmunge-0.85.tar.gz
---

# CMunge 0.85

Source for the RISC OS module-interface generator. Its native POSIX build is
used by the RISC OS toolbox so current module descriptions are compiled by the
matching generation of CMunge rather than GCCSDK's older bundled copy.

Based on upstream v0.85 with GNU assembler invocation and output-attribute
fixes from the tested `mountin-2026-09-15` fork tag.
