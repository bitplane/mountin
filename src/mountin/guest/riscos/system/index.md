---
title: RISC OS BCM2835 2026-09-09 guest components
output_platforms:
  arm-riscos:
    requires:
      - docker:builder/compiler/riscos/system
    provides:
      - guest/arm-riscos/system
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
| SDFS → FileCore | SD/MMC FileCore discs | New-map whole-device image passes 9P read/write and reboot persistence. Old-map with new directories passes 9P reads; the old-map old-directory fixture returns `Bad defect list` at its root. |
| USBDriver → DWCDriver → SCSISoftUSB → SCSIFS | SCSI media through the Pi USB host; SCSIFS has partition-offset code | The appliance verifier reads QEMU USB FAT12, FAT16 and FAT32 files at `/SCSI-4`, checks FAT16 write persistence across reboot, and alternates reads between two FAT16 disks at `/SCSI-4` and `/SCSI-5`. Paged FAT12 enumeration returns each entry once. The DWC transfer-length fix prevents stale bulk data from corrupting SCSI status replies. |
| CDFSDriver → CDFSSoftSCSI → CDFS | CD media on the SCSI path | The appliance verifier reads plain ISO 9660, Joliet, Rock Ridge and High Sierra CD files at `/CDFS`; it checks paged Joliet and High Sierra directories and reads the plain ISO with a USB disk attached. CDFSSoftSCSI uses READ(10) when the device rejects READ HEADER and limits MODE SENSE page parsing to the length declared in the response header. |
| DOSFS | FAT filesystem images stored as RISC OS files; its image parser also checks for an MBR | FAT12, FAT16 and FAT32 files and directories pass fixture-backed 9P reads, both with raw images and with an MBR inside each image file. A raw FAT16 ImageFS file also passes write persistence across reboot. |
| ResourceFS | ROM resources | The verifier enumerates `/Resources/Mountin/9d` and reads the embedded executable through 9P. The filing system is read only. |
| DeviceFS and SystemDevices | Device streams | The verifier enumerates `Serial1` and `USB1` at `/devices`. The live serial stream carries 9P traffic and is not read as a regular file. |
| PipeFS | Named pipes | The verifier walks and reads `/Pipe`. No named pipe is created by this appliance. |
| ADFS | Acorn FileCore volumes | Source is present; no ADFS module is selected for this ROM. |
| RAMFS | Memory backed files | Source is present; the module is not selected for this ROM. |
| NetFS | Network file service | Source is present; the module and network stack are not selected for this ROM. |
| PCCardFS | PC Card storage | Source is present; the module is not selected for this ROM. |
| HostFS | Emulator host files | Source is present; the module is not selected for this ROM. |
| OmniLanManFS | LAN Manager shares | Source is present; the module and network stack are not selected for this ROM. |

With only the SD card attached, 9d lists `/Pipe`, `/Resources`, `/SDFS`, and
`/devices`. With the USB FAT16 disk and ISO CD attached, it also lists
`/SCSI-4` and `/CDFS`. Some virtual filing systems reject `OS_File` on their
volume root even though `OS_GBPB` enumerates it. 9d probes directory access
when that happens and converts nested RISC OS path components to native dot
separators. The verifier checks the ROM roots and the conditional media roots.

The seven `basic.filecore-fat*` fixtures hold DOSFS image files in old-map
FileCore host filesystems. The guest boots each host through SDFS, then 9d
lists and reads the image contents through ImageFS. The verifier writes to a
disposable FAT16 ImageFS volume and checks the data after reboot. MBR parsing
inside DOSFS image files is verified for FAT12, FAT16 and FAT32, including
preference for a bootable second partition; whole-device
partitioned media remains unverified because PartitionManager is absent from
this product.
The standalone `basic.filecore-oldmap-newdir` fixture passes a whole-device
SDFS read. `basic.filecore-oldmap`, which uses old directories, returns
FileCore's `Bad defect list` error at its root. Disc Image Manager's `OO20M`
layout places file data at the hard-disc defect-list address. Reserving that
area and generating directory check bytes advances the guest to `Broken
directory`. A genuine ADFS L old-directory image returns `Broken directory`
on SD and `Bad defect list` over USB. FileCore contains old-directory code,
but this BCM2835 appliance has no verified route to it. The source does not
include PartMan, the helper
that selects SCSIFS partition offsets, so whole-device MBR and GPT media
cannot yet be exercised through this ROM.

The USB and CD tests attach `basic.fat12`, `basic.fat16`, `basic.fat32`,
`basic.iso9660`, `basic.joliet.iso9660`, `basic.rock-ridge.iso9660`, and
`basic.highsierra` as removable media. A second FAT16 disk gets a distinct
volume serial. The complete appliance verifier passes its single-CD,
two-disk and combined-media release gates. It paces incoming request bytes at
10 ms so DeviceFS retains each frame. RISC OS 9d uses a dedicated serial
output path that retries when the driver queue is full; UnixLib's generic tty
writer reports success even when that queue drops a byte.

The earlier directory stalls were in UnixLib `lstat` after native `OS_GBPB`
returned an entry. 9d now obtains RISC OS metadata through `OS_File`, so
FAT12, Joliet and High Sierra directory reads reach the end and their files
can be read. Native FileSwitch directory cursors skip FAT directory metadata
entries that UnixLib exposed as duplicates. All three pass exact paged-entry
and distinct 9P identity checks. `basic.udf-optical`
exposes no CDFS root; the selected CDFS module has no UDF reader and the
product source has no UDF filing-system module. The appliance verifier gates
the successful paths listed above; other catalogue fixtures are not RISC OS
coverage.
