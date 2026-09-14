#!/bin/bash
set -eu

root=/opt/mountin/source/RiscOS
system=/host/build/guest/arm-riscos/2026-09-09/system
rom=$root/Images/BCM2835Mountin
fixture=/host/build/data/fs/basic.filecore
qemu=/host/build/bin/qemu-system/${MOUNTIN_BUILD_ARCH}-linux-musl/qemu-system-arm
output=/host/build/bin/qemu/arm-riscos/2026-09-09/rom

cp -a "$system/." "$root/"
sed -e 's/^%Image .*/%Image BCM2835Mountin/' \
    -e 's/^%Log .*/%Log BCM2835Mountin/' \
    -e '/^UnSqzAIF$/i MountinLauncher' \
    "$root/BuildSys/Components/ROOL/BCM2835PicoHeadless" \
    > "$root/BuildSys/Components/ROOL/BCM2835Mountin"
launcher=$root/Sources/MountinLauncher
resources=$root/Sources/MountinResources
mkdir -p "$launcher/s" "$resources/data/Mountin"
cp /build/launcher.GNUmakefile "$launcher/GNUmakefile"
cp /build/launcher.s "$launcher/s/MountinLauncher"
cp /host/build/bin/arm-riscos/9d "$resources/data/Mountin/9d,ff8"
cat >> "$root/BuildSys/ModuleDB" <<'EOF'
MountinLauncher             ASM   Sources.MountinLauncher                                              Mountin         MountinLauncher
EOF

cd "$root"
export GCCSDK_INSTALL_CROSSBIN=/opt/gccsdk/cross/bin TOOLCHAIN=GNU DDE=no
. Env/ROOL/BCM2835Pico.sh
unset COMPONENT TARGET INSTDIR
export BUILD=ROOL/BCM2835Mountin

cd "$resources"
mkresfs -o c/resfs -p h/resfs -v data
sed -i '/static const unsigned char payload\[\] =/i __attribute__((section(".text.resources")))' c/resfs
arm-unknown-riscos-gcc -x c -c -Os \
    -I"$LIBDIR/RISC_OSLib" -I"$CEXPORTDIR" -I"$LIBDIR" \
    c/resfs -o resfs.o
arm-unknown-riscos-objcopy -O binary --only-section=.text.resources \
    resfs.o resources.bin

cd "$root"
srcbuild install_rom
srcbuild join

python3 /build/verify.py "$qemu" "$rom" "$fixture"
mkdir -p "${output%/*}"
cp "$rom" "$output"
