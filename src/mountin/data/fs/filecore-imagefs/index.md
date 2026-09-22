---
format: fs/filecore
build_requires:
  - sources/disc-image-manager-1.50.1.tar.gz
requires:
  - docker:builder/disk/debian
  - data/templates/basic.tar
  - data/fs/basic.dosfs-fat12
  - data/fs/basic.fat16
  - data/fs/basic.fat32
  - data/pt/basic-fat12.mbr
  - data/pt/basic-fat16.mbr
  - data/pt/basic-fat32.mbr
  - data/pt/basic-fat-multi.mbr
provides:
  - data/fs/basic.filecore-fat12
  - data/fs/basic.filecore-fat12-mbr
  - data/fs/basic.filecore-fat16
  - data/fs/basic.filecore-fat16-mbr
  - data/fs/basic.filecore-fat32
  - data/fs/basic.filecore-fat32-mbr
  - data/fs/basic.filecore-fat-multi-mbr
---

# FileCore ImageFS test image

Old-map FileCore images containing the standard test-data tree and one file
with the RISC OS `MSDOSDisc` file type. Each of FAT12, FAT16 and FAT32 has a
raw image and a matching MBR variant. RISC OS DOSFS should present each file
as an ImageFS directory. A seventh host contains a mixed MBR with active FAT12
after nonbootable FAT16. The builder extracts and compares the embedded image
after saving so a corrupt FileCore map cannot pass silently.
