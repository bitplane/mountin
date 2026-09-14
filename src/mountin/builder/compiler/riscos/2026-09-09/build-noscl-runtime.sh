#!/bin/sh
set -eu

export PATH=/opt/gccsdk/cross/bin:$PATH
runtime=/opt/rool/lib
unixlib=/opt/gccsdk/cross/arm-unknown-riscos/lib/libunixlib.a
work=/work/noscl-runtime

mkdir -p "$runtime" "$work"
cd "$work"
arm-unknown-riscos-ar x "$unixlib" \
    _swi.o kswi.o _memcpy.o _memset.o _strcpy.o _strlen.o \
    strchr.o strcmp.o strncpy.o
arm-unknown-riscos-gcc -mmodule -ffreestanding -march=armv6 -mfpu=fpe3 \
    -mlibscl -mno-apcs-stack-check -O2 \
    -S /build/noscl-runtime.c -o noscl-runtime.s
arm-unknown-riscos-as -march=armv6 -mfpu=fpe3 -mfloat-abi=soft \
    -o noscl-runtime.o noscl-runtime.s
arm-unknown-riscos-ar rcs "$runtime/noscl.a" ./*.o
