---
format: fs/filecore
build_requires:
  - sources/disc-image-manager-1.50.5.tar.gz
requires:
  - docker:builder/disk/debian
  - data/templates/basic.tar
provides:
  - data/fs/basic.filecore
  - data/fs/basic.filecore-oldmap
  - data/fs/basic.filecore-oldmap-newdir
---

# Filecore test image

New-map and old-map ADFS hard-disk images containing the standard test-data
tree. Disc Image Manager creates a new-map image with `NN20M`, an old-map
old-directory image with `OO20M`, and an old-map new-directory image with
`ON20M`. All are whole-device FileCore images, so they
do not claim partition-table support. The RISC OS appliance verifies the
new-map image through SDFS/FileCore and 9P, including write persistence
across reboot. It also exercises NetBSD's native FileCore reader. The
old-map old-directory image reserves its hard-disc boot record outside the free
space map, maintains native directory checks and gives imported files native
read/write permissions. A development ROM with the FileCore and SDFS fixes
reads the generated fixture through 9P; those driver releases are still pending
integration into the pinned guest.
