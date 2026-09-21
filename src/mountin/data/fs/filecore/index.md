---
format: fs/filecore
build_requires:
  - sources/disc-image-manager-1.50.1.tar.gz
requires:
  - docker:builder/disk/debian
  - data/templates/basic.tar
provides:
  - data/fs/basic.filecore
  - data/fs/basic.filecore-oldmap
---

# Filecore test image

New-map and old-map ADFS hard-disk images containing the standard test-data
tree. Disc Image Manager creates the new-map image with `NN20M` and the
old-map image with `OO20M`. Both are whole-device FileCore images, so they
do not claim partition-table support. The RISC OS appliance verifies the
new-map image through SDFS/FileCore and 9P, including write persistence
across reboot. It also exercises NetBSD's native FileCore reader. The old-map image is retained for driver coverage work; the
current SDFS appliance returns an I/O error when reading its root.
