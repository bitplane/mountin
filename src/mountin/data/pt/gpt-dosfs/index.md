---
format: pt/gpt
requires:
  - docker:builder/disk/alpine
build_requires:
  - data/fs/basic.fat16
  - data/fs/basic.fat32
provides:
  - data/pt/basic-fat-multi.gpt
---

# GPT FAT test image

A FAT16 partition followed by a FAT32 partition, both with Microsoft Basic
Data type GUIDs. Each contains the basic fixture tree and a distinct
`PART.TXT` marker (`FAT16 partition` or `FAT32 partition`). These markers
prove that a guest reads each partition at its own offset. The image includes
the primary and backup GPT headers and partition arrays.
