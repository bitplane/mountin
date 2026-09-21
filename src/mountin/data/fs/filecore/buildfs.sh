#!/bin/sh
set -eu

input=$1
output=$2
commands=/tmp/filecore.commands
case $output in
    *.filecore-oldmap) layout=OO20M ;;
    *) layout=NN20M ;;
esac

{
    printf 'new ADFS HDD %s\n' "$layout"
    echo 'title basic'
    printf 'add "%s"\n' "$input/*"
    printf 'save "%s"\n' "$output"
    echo 'exit'
} > "$commands"

disc-image-manager -s "$commands" -n
test -s "$output"
