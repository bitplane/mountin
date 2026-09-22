---
format: fs/fat12
requires:
  - docker:builder/disk/alpine
  - data/templates/basic.tar
provides:
  - data/fs/basic.dosfs-fat12
---

# DOSFS FAT12 test image

Standard 1.44 MiB FAT12 floppy geometry for exercising the RISC OS DOSFS
ImageFS driver.
