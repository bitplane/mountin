---
title: RedSea
related:
  - format/fs/fat32
detect:
  - offset: 3
    type: u8
    value: 0x88
    then:
      - offset: 0x1FE
        type: le16
        value: 0xAA55
      - offset: 16
        type: le64
        name: sectors
      - offset: 24
        type: le64
        name: root_block
      - offset: 32
        type: le64
        name: bitmap_sectors
---

# RedSea

RedSea is the native filesystem of TempleOS. Terry A. Davis designed it as a
small 64-bit filesystem for whole-file operations and direct inspection as the
Lord intended. It is used on hard-disk partitions and, with an El Torito
wrapper, on TempleOS distribution discs and `.ISO.C` package images.

## Structure

The first 512-byte sector contains a `CRedSeaBoot` record. Byte 3 is the RedSea
signature `0x88`, and the sector ends with the PC boot signature `0xAA55`.
Multi-byte fields are little-endian.

| Offset | Size | Field |
|---:|---:|---|
| 0 | 3 | Boot jump and padding |
| 3 | 1 | RedSea signature, `0x88` |
| 4 | 4 | Reserved |
| 8 | 8 | Drive offset used by optical images |
| 16 | 8 | Volume size in sectors |
| 24 | 8 | Root-directory block |
| 32 | 8 | Allocation-bitmap size in sectors |
| 40 | 8 | Unique volume identifier |
| 48 | 462 | Boot code |
| 510 | 2 | Boot signature, `0xAA55` |

RedSea uses 512-byte blocks, an allocation bitmap and fixed 64-byte directory
entries. Directory entries contain a 38-byte zero-terminated name, attributes,
an absolute starting block, a byte length and a timestamp. Files occupy one
contiguous extent and cannot grow in place; changing their size reallocates and
rewrites them.

There is no file-allocation table, journal, bad-block table or redundant
allocation metadata. Files whose names end in `.Z` are transparently compressed
by TempleOS when stored and decompressed when read.

## Partition and optical-media conventions

TempleOS uses MBR partition type `0x88` for RedSea. Historical boot machinery
may present the partition as FAT32 even though its contents are not FAT.

A RedSea optical image is not an ISO 9660 filesystem. TempleOS places a RedSea
volume into an El Torito bootable disc layout, mapping four 512-byte RedSea
blocks onto each 2048-byte optical sector. The same filesystem driver is used
after accounting for the stored drive offset.

## References

- [TempleOS RedSea documentation](https://tinkeros.github.io/WbGit/Doc/RedSea.html)
- [TempleOS `FileSysRedSea.HC`](https://github.com/cia-foundation/TempleOS/blob/c26482b/Kernel/BlkDev/FileSysRedSea.HC)
- [TempleOS `DskISORedSea.HC`](https://github.com/cia-foundation/TempleOS/blob/c26482b/Adam/Opt/Boot/DskISORedSea.HC)
