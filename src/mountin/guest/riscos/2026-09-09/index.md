---
title: RISC OS BCM2835 2026-09-09 guest components
output_platforms:
  arm-riscos:
    requires:
      - docker:builder/compiler/riscos/2026-09-09
    provides:
      - guest/arm-riscos/2026-09-09/system
---

# RISC OS BCM2835 2026-09-09 guest components

Prepared headless BCM2835 operating-system build, including the Pi fixes,
compiled kernel and storage modules, OS resources, exported headers, libraries
and source needed for ROM linking. The system directory preserves the upstream
RiscOS tree layout so appliance assembly can continue the build with the same
toolbox. It contains no 9d binary or application launcher.

The product selects `MINIMAL_CLIB=yes` for SharedCLibrary, omitting its complex
and math implementations. This is an appliance choice; the library's upstream
build defaults are unchanged by the GNU port.

`BCM2835PicoHeadless` also selects the early boot modules, fixed serial modem
status, startup module and embedded territory handling. The corresponding
controls live in the OS component forks; the appliance's names and values
remain in this product definition. The kernel's minimal boot mode omits
display/keyboard startup and some peripheral initialization, so it is intended
for this reduced ROM rather than a full desktop system without a screen.

The verified storage path is SDIODriver → SDFS → FileCore. SDFS presents an
SD/MMC device as a FileCore disc and reads its geometry from the FileCore boot
block. The current ROM profile contains this path and serves a whole-device,
new-map FileCore image through 9d. The 9d synthetic root enumerates active
filing systems and exposes this volume at `/SDFS`, backed by `SDFS::0.$`.

The upstream BCM2835 product has additional filing systems and device drivers.
The HAL's `BOOT_MODULES` option lists only the core keyboard-scan boot
dependencies. USB SCSI and CDFS remain in the ROM, but adding them to that
HAL dependency string stalls a clean boot; the launcher initializes the
removable-media drivers after startup.
The table records what is present in that source and what the current guest
can actually use:

| Driver path | Source capability | Current guest result |
| --- | --- | --- |
| SDFS → FileCore | SD/MMC FileCore discs | New-map whole-device image passes 9P read/write and reboot persistence. Old-map with new directories passes 9P reads; old-map with old directories returns an I/O error at its root. |
| USBDriver → DWCDriver → SCSISoftUSB → SCSIFS | SCSI media through the Pi USB host; SCSIFS has partition-offset code | The appliance verifier reads QEMU USB FAT16 and FAT32 disks at `/SCSI-4` and alternates reads between two FAT16 disks at `/SCSI-4` and `/SCSI-5`, closing each 9P file. The DWC transfer-length fix prevents stale bulk data from corrupting SCSI status replies. |
| CDFSDriver → CDFSSoftSCSI → CDFS | CD media on the SCSI path | The appliance verifier reads plain ISO 9660 and Rock Ridge CD files at `/CDFS`; it also reads the plain ISO with a USB disk attached. CDFSSoftSCSI uses READ(10) when the device rejects READ HEADER and limits MODE SENSE page parsing to the length declared in the response header. |
| DOSFS | FAT filesystem images stored as RISC OS files; its image parser also checks for an MBR | The module is included in the ROM. FAT12, FAT16 and FAT32 files and directories pass fixture-backed 9P reads, both with raw images and with an MBR inside each image file. |
| ADFS | Exported headers in this BCM2835 product | No ADFS filing-system module is selected for the ROM. |

The seven `basic.filecore-fat*` fixtures hold DOSFS image files in old-map
FileCore host filesystems. The guest boots each host through SDFS, then 9d
lists and reads the image contents through ImageFS. MBR parsing inside DOSFS
image files is therefore verified for FAT12, FAT16 and FAT32, including
preference for a bootable second partition; whole-device
partitioned media remains unverified because PartitionManager is absent from
this product.
The standalone `basic.filecore-oldmap-newdir` fixture passes a whole-device
SDFS read. `basic.filecore-oldmap`, which uses old directories, still returns
an I/O error at its root. The BCM2835 source does not include PartMan, the
helper that selects SCSIFS partition offsets, so whole-device MBR and GPT
media cannot yet be exercised through this ROM.

The USB and CD tests attach `basic.fat16`, `basic.fat32`,
`basic.iso9660`, and `basic.rock-ridge.iso9660` as removable media. A
second FAT16 disk gets a distinct volume serial.
With 10 ms between serial bytes, the complete appliance verifier passes its
single-CD, two-disk, and combined-media release gates. A diagnostic run with
50 ms between bytes stalled during a later 9P request: QEMU delivered the
whole request to the guest PL011, but 9d received only part of its body.
The faster test pacing avoids that observed stall; broader serial transport
reliability remains to be assessed with other clients.
Direct USB `basic.fat12` and CD `basic.joliet.iso9660` and
`basic.high-sierra.iso9660` expose their roots, but a fixture-directory read
stalls in repeat probes. `basic.udf-optical` exposes no CDFS root. These
observations do not establish whether the filing systems or the serial 9P
path caused the stalls. The appliance verifier gates only the successful
file reads listed above; other catalogue fixtures are not RISC OS coverage.
