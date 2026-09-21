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
new-map FileCore image through 9d. Its launcher selects `SDFS::0.$`.

The upstream BCM2835 product has additional filing systems and device drivers.
The table records what is present in that source and what the current guest
can actually use:

| Driver path | Source capability | Current guest result |
| --- | --- | --- |
| SDFS → FileCore | SD/MMC FileCore discs | New-map whole-device image passes 9P read/write and reboot persistence. An old-map image returns an I/O error at its root. |
| USBDriver → DWCDriver → SCSISoftUSB → SCSIFS | SCSI media through the Pi USB host; SCSIFS has partition-offset code | Not selected by the current ROM and no media test has passed. |
| CDFSDriver → CDFSSoftSCSI → CDFS | CD media on the SCSI path | Not selected by the current ROM and no media test has passed. |
| DOSFS | FAT filesystem images stored as RISC OS files; its image parser also checks for an MBR | The GNU toolbox does not link DOSFS yet. No FAT or MBR support is advertised. |
| ADFS | Exported headers in this BCM2835 product | No ADFS filing-system module is selected for the ROM. |

The existing `basic.filecore`, `basic.filecore-oldmap`, `basic.fat16`, and
`basic.iso9660` fixtures cover candidate media layouts. DOSFS also needs a
FileCore host image containing a FAT image file, and its MBR branch needs an
image file containing an MBR and FAT partition. PartitionManager is absent from
this product, so the guest advertises no partition-table support.
