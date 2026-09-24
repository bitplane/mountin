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
old-map old-directory image is retained for driver coverage work. The current
SDFS appliance reports `Bad defect list` on its root because the generator's
`OO20M` layout places file data at the hard-disc defect-list address. A
diagnostic image with that area reserved and directory checksums filled in
reaches `Broken directory`, so this fixture is not yet a verified old-directory
test for the guest.
