#!/bin/bash
set -eu

buildhost=/opt/mountin/sources/buildhost/RiscOS
srcbuild=$buildhost/Utilities/Release/srcbuild
clxlite=$buildhost/Sources/Lib/CLXLite
objects=/tmp/srcbuild
romlinker=$buildhost/Utilities/Release/romlinker
decgen=/opt/mountin/sources/decgen
tokenise=$buildhost/Tools/Sources/tokenise/c/tokenise

cd /opt/mountin/sources/gccsdk
export GCCSDK_ROOT=$PWD
. ./setup-gccsdk-params
export GCCSDK_MAKE_ARGS="-j$MOUNTIN_BUILD_JOBS"
unset CC AR STRIP RANLIB

mkdir -p /opt/rool/bin "$objects/include/CLib" "$objects/obj"
ln -s "$buildhost/Sources/Lib/RISC_OSLib/clib/h/kernel" \
    "$objects/include/CLib/kernel.h"
for header in "$srcbuild"/h/* "$clxlite"/h/*; do
    name=${header##*/}
    ln -s "$header" "$objects/include/$name.h"
done
for header in "$romlinker"/h/*; do
    name=${header##*/}
    ln -s "$header" "$objects/include/$name.h"
done
ln -s "$romlinker/VersionNum" "$objects/include/VersionNum"

for source in srcbuild riscos build parse; do
    cc -x c -std=gnu11 -D_GNU_SOURCE -O2 \
        -I"$srcbuild" -I"$srcbuild/h" -I"$clxlite/h" \
        -I"$objects/include" \
        -c "$srcbuild/c/$source" -o "$objects/obj/$source.o"
done

for source in err hash host prgname wholefls; do
    cc -x c -std=gnu11 -D_GNU_SOURCE -O2 \
        -I"$clxlite/h" -I"$objects/include" \
        -c "$clxlite/c/$source" -o "$objects/obj/clx-$source.o"
done

cc "$objects"/obj/srcbuild.o \
    "$objects"/obj/riscos.o \
    "$objects"/obj/build.o \
    "$objects"/obj/parse.o \
    "$objects"/obj/clx-err.o \
    "$objects"/obj/clx-hash.o \
    "$objects"/obj/clx-host.o \
    "$objects"/obj/clx-prgname.o \
    "$objects"/obj/clx-wholefls.o \
    -o /opt/rool/bin/srcbuild

ar rcs "$objects/clxlite.a" \
    "$objects"/obj/clx-err.o \
    "$objects"/obj/clx-hash.o \
    "$objects"/obj/clx-host.o \
    "$objects"/obj/clx-prgname.o \
    "$objects"/obj/clx-wholefls.o

for source in filereader filewriter romlinker memory makerom makeexprom; do
    cc -x c -std=gnu11 -D_GNU_SOURCE -O2 \
        -I"$objects/include" \
        -c "$romlinker/c/$source" -o "$objects/obj/rom-$source.o"
done
cc "$objects"/obj/rom-*.o "$objects/clxlite.a" \
    -o /opt/rool/bin/romlinker

c++ -std=gnu++11 -O2 "$decgen"/source/*.cc -o /opt/rool/bin/decgen
cp -a "$decgen/encodings" /opt/rool/decgen-encodings
cc -x c -std=c99 -O2 "$tokenise" -o /opt/rool/bin/Tokenise

rm -rf "$objects"
