---
format: fs/redsea
requires:
  - docker:builder/compiler/aiwnios/2026-02-02
build_requires:
  - data/templates/basic.tar
provides:
  - data/fs/basic.redsea
---

# RedSea Test Image

Raw RedSea filesystem created by the source-built AIWNIOS HolyC runtime and
populated from Mountin's standard fixture tree. The same runtime remounts the
completed in-memory image and verifies its contents before publishing it.

