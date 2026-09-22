#!/bin/sh
set -eu

input=$1
output=$2
commands=/tmp/filecore-imagefs.commands
variant=${output##*basic.filecore-}
case $variant in
    fat12|fat16|fat32)
        filesystem=$variant
        partitioned=false
        ;;
    fat12-mbr|fat16-mbr|fat32-mbr)
        filesystem=${variant%-mbr}
        partitioned=true
        ;;
    *)
        echo "Unknown FileCore ImageFS target: $output" >&2
        exit 1
        ;;
esac
name=$(printf '%s' "$filesystem" | tr '[:lower:]' '[:upper:]')
if [ "$partitioned" = true ]; then
    image=/host/build/data/pt/basic-$filesystem.mbr
    name=${name}MBR
elif [ "$filesystem" = fat12 ]; then
    image=/host/build/data/fs/basic.dosfs-fat12
else
    image=/host/build/data/fs/basic.$filesystem
fi

capacity=20
if [ "$(stat -c %s "$image")" -gt $((18 * 1024 * 1024)) ]; then
    capacity=40
fi
cp "$image" "/tmp/$name"
rm -f "$output"

{
    printf 'new ADFS HDD ON%sM\n' "$capacity"
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
