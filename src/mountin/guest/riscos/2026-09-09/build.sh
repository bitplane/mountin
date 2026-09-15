#!/bin/bash
set -eu

root=/opt/mountin/source/RiscOS
output=/host/build/guest/arm-riscos/2026-09-09/system

cp /build/BCM2835PicoHeadless \
    "$root/BuildSys/Components/ROOL/"
resources="$root/Sources/MountinResources"
sharedulib="$root/Sources/MountinSharedULib"
mkdir -p "$resources/s" "$resources/c" "$resources/h" \
    "$resources/data/Resources" \
    "$sharedulib/s"

install_messages() {
    destination="$1"
    shift
    mkdir -p "$resources/data/Resources/$destination"
    sed '/^#{DictTokens}$/d' "$@" \
        > "$resources/data/Resources/$destination/Messages"
}
cp /build/resources.GNUmakefile "$resources/GNUmakefile"
cp /build/resources.s "$resources/s/MountinResources"
cp /build/sharedulib.GNUmakefile "$sharedulib/GNUmakefile"
cp /build/sharedulib.s "$sharedulib/s/SharedULib"
cp /opt/mountin/build/cross-gcc/arm-unknown-riscos/libunixlib/sul \
    "$sharedulib/SharedULib"
install_messages FileCore \
    "$root/Sources/FileSys/FileCore/Resources/UK/Messages" \
    "$root/Sources/FileSys/FileCore/Resources/UK/CmdHelp"
install_messages FileSwitch \
    "$root/Sources/FileSys/FileSwitch/Resources/UK/Messages" \
    "$root/Sources/FileSys/FileSwitch/Resources/UK/CmdHelp"
install_messages ResourceFS \
    "$root/Sources/FileSys/ResourceFS/ResourceFS/Resources/UK/Messages" \
    "$root/Sources/FileSys/ResourceFS/ResourceFS/Resources/UK/CmdHelp"
install_messages MsgTrans \
    "$root/Sources/Internat/MsgTrans/Resources/UK/Messages"
install_messages Obey \
    "$root/Sources/Programmer/Obey/Resources/UK/Messages" \
    "$root/Sources/Programmer/Obey/Resources/UK/CmdHelp"
install_messages PipeFS \
    "$root/Sources/FileSys/PipeFS/Resources/UK/Messages" \
    "$root/Sources/FileSys/PipeFS/Resources/UK/CmdHelp"
install_messages SystemDevs \
    "$root/Sources/HWSupport/SystemDevs/Resources/UK/Messages"
install_messages SDIODriver \
    "$root/Sources/HWSupport/SD/SDIODriver/Resources/UK/Messages" \
    "$root/Sources/HWSupport/SD/SDIODriver/Resources/UK/CmdHelp"
install_messages SDFS \
    "$root/Sources/FileSys/SDFS/SDFS/Resources/UK/Messages" \
    "$root/Sources/FileSys/SDFS/SDFS/Resources/UK/CmdHelp"
install_messages DualSerial \
    "$root/Sources/HWSupport/DualSerial/Resources/UK/Messages"
install_messages Serial \
    "$root/Sources/HWSupport/Serial/Resources/UK/Messages"
install_messages Buffers \
    "$root/Sources/HWSupport/Buffers/Resources/UK/Messages"
install_messages DeviceFS \
    "$root/Sources/HWSupport/DeviceFS/Resources/UK/Messages"

cat >> "$root/BuildSys/ModuleDB" <<'EOF'
MountinResources            ASM   Sources.MountinResources                                             Mountin         MountinResources
MountinSharedULib           ASM   Sources.MountinSharedULib                                            Mountin         SharedULib
EOF

cd "$root"
export GCCSDK_INSTALL_CROSSBIN=/opt/gccsdk/cross/bin
export TOOLCHAIN=GNU
export DDE=no
. Env/ROOL/BCM2835Pico.sh
unset COMPONENT TARGET INSTDIR

mkdir -p "$CEXPORTDIR/Global" "$GLOBALHDRDIR"

srcbuild export_hdrs
riscoslib="$root/Sources/Lib/RISC_OSLib"
make -C "$riscoslib" links
make -C "$riscoslib" CLIBEXPLIBS= RLIBEXPLIBS= export_libs
make -C "$riscoslib/objs" -f ../GNUmakefile romcstubs.a
cp "$riscoslib/objs/romcstubs.a" "$LIBDIR/RISC_OSLib/romcstubs.a"
make -C "$root/Sources/Lib/AsmUtils" export_libs
make -C "$root/Sources/Lib/SyncLib" export_libs
export BUILD=ROOL/BCM2835PicoHeadless

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
mkdir -p "$output"
cp -a "$root/." "$output/"
