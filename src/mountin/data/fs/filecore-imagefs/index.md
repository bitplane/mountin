---
format: fs/filecore
build_requires:
  - sources/disc-image-manager-1.50.1.tar.gz
requires:
  - docker:builder/disk/debian
  - data/templates/basic.tar
  - data/fs/basic.dosfs-fat12
  - data/pt/basic-fat12.mbr
provides:
  - data/fs/basic.filecore-fat12
  - data/fs/basic.filecore-fat12-mbr
---

# FileCore ImageFS test image

Old-map FileCore images containing the standard test-data tree and one file
with the RISC OS `MSDOSDisc` file type. `basic.filecore-fat12` contains an
unpartitioned FAT12 image named `FAT12`; `basic.filecore-fat12-mbr` contains
the compact MBR fixture as `FATMBR`. RISC OS DOSFS should present each file as
an ImageFS directory.
