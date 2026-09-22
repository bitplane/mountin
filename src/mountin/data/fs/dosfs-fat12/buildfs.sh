#!/bin/sh
set -eu

input=$1
output=$2
truncate -s 1440K "$output"
mkfs.fat -F 12 -S 512 "$output"

export MTOOLSRC=/tmp/mtoolsrc
printf 'drive c: file="%s"\n' "$output" > "$MTOOLSRC"
mmd c:/BASIC
mcopy -o "$input/basic/hello.txt" c:/BASIC/HELLO.TXT
