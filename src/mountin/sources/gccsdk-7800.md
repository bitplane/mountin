---
title: GCCSDK r7800
version: "7800"
urls:
  - https://github.com/bitplane/gccsdk/releases/download/mountin-2026-09-15/gccsdk-7800.tar.gz
provides:
  - sources/gccsdk-7800.tar.gz
---

# GCCSDK r7800

Based on canonical GCCSDK Subversion revision 7800 from
`svn://svn.riscos.info/gccsdk/trunk/gcc4`, with the tested cross-build fixes
in the fork's `mountin-2026-09-15` tag. GCCSDK carries the RISC OS ports of
GCC, binutils, UnixLib and the supporting host tools.

The source distribution includes the ASASM, decaof and elftoolchain SVN
externals. The fork preserves their upstream history; its contribution branches
separate assembler fixes, SharedCLibrary code generation and host-only builds.
