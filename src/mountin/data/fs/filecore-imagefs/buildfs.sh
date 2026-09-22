#!/bin/sh
set -eu

input=$1
output=$2
commands=/tmp/filecore-imagefs.commands
case $output in
    *-mbr)
        image=/host/build/data/pt/basic-fat12.mbr
        name=FATMBR
        ;;
    *)
        image=/host/build/data/fs/basic.dosfs-fat12
        name=FAT12
        ;;
esac
cp "$image" "/tmp/$name"

{
    echo 'new ADFS HDD ON20M'
    echo 'title imagefs'
    printf 'add "%s"\n' "$input/*"
    printf 'add "/tmp/%s"\n' "$name"
    printf 'type %s FC8\n' "$name"
    printf 'access %s WR\n' "$name"
    printf 'save "%s"\n' "$output"
    echo 'exit'
} > "$commands"

disc-image-manager -s "$commands" -n
test -s "$output"

{
    printf 'insert "%s"\n' "$output"
    printf 'extract "%s"\n' "$name"
    echo 'exit'
} > "$commands"
cd /tmp
disc-image-manager -s "$commands" -n
cmp "$image" "/tmp/$name,FC8"
