FROM builder/compiler/riscos/7800 AS host-tools

ARG MOUNTIN_BUILD_JOBS=1

RUN mkdir -p /opt/mountin/sources/buildhost /opt/rool/bin && \
    tar --no-same-owner -xzf \
        /host/build/sources/riscos-buildhost-2025-05-17.tar.gz \
        -C /opt/mountin/sources/buildhost --strip-components=1

RUN mkdir -p /opt/mountin/sources/decgen && \
    unzip -q /host/build/sources/riscos-decgen-1.41b.zip \
        -d /opt/mountin/sources/decgen

COPY --chmod=755 build-cmunge.sh /build-cmunge.sh
RUN /build-cmunge.sh

COPY srcbuild-posix.patch clxlite-posix.patch /patches/
COPY --chmod=755 build-host-tools.sh /build-host-tools.sh
RUN /build-host-tools.sh

FROM host-tools

COPY bcmsupport-gnu.patch buildsys-gnu.patch hal-bcm2835-gnu.patch \
    haldevice-header-guard.patch kernel-gnu.patch kernel.ld module.ld \
    riscoslib-gnu.patch riscoslib-gcc.patch sharedclib.ld rtsupport-cmunge.patch sdiodriver-gnu.patch \
    sdfs-gnu.patch /patches/
RUN rm /opt/mountin/source /opt/mountin/build && \
    ln -s /opt/mountin/sources/gccsdk/builddir /opt/mountin/build && \
    mkdir -p /opt/mountin/sources/riscos && \
    ln -s /opt/mountin/sources/riscos /opt/mountin/source && \
    tar --no-same-owner -xzf \
        /host/build/sources/riscos-bcm2835-2026-09-09.tar.gz \
        -C /opt/mountin/sources/riscos --strip-components=1 && \
    rm -rf /opt/mountin/sources/riscos/RiscOS/Sources/Internat/Territory/TerritoryManager && \
    mkdir -p /opt/mountin/sources/riscos/RiscOS/Sources/Internat/Territory/TerritoryManager && \
    tar --no-same-owner -xzf \
        /host/build/sources/riscos-territory-manager-0.58.tar.gz \
        -C /opt/mountin/sources/riscos/RiscOS/Sources/Internat/Territory/TerritoryManager \
        --strip-components=1 && \
    patch -d /opt/mountin/sources/riscos/RiscOS/BuildSys -p1 \
        < /patches/buildsys-gnu.patch && \
    patch -d /opt/mountin/sources/riscos/RiscOS/Sources/HAL/HAL_BCM2835 -p1 \
        < /patches/hal-bcm2835-gnu.patch && \
    patch -d /opt/mountin/sources/riscos/RiscOS/Sources/Kernel -p1 \
        < /patches/haldevice-header-guard.patch && \
    patch -d /opt/mountin/sources/riscos/RiscOS/Sources/Kernel -p1 \
        < /patches/kernel-gnu.patch && \
    patch -d /opt/mountin/sources/riscos/RiscOS/Sources/HWSupport/BCMSupport -p1 \
        < /patches/bcmsupport-gnu.patch && \
    patch -d /opt/mountin/sources/riscos/RiscOS/Sources/Lib/RISC_OSLib -p1 \
        < /patches/riscoslib-gnu.patch && \
    patch -d /opt/mountin/sources/riscos/RiscOS/Sources/Lib/RISC_OSLib -p1 \
        < /patches/riscoslib-gcc.patch && \
    patch -d /opt/mountin/sources/riscos/RiscOS/Sources/Programmer/RTSupport -p1 \
        < /patches/rtsupport-cmunge.patch && \
    patch -d /opt/mountin/sources/riscos/RiscOS/Sources/HWSupport/SD/SDIODriver -p1 \
        < /patches/sdiodriver-gnu.patch && \
    patch -d /opt/mountin/sources/riscos/RiscOS/Sources/FileSys/SDFS/SDFS -p1 \
        < /patches/sdfs-gnu.patch && \
    cp /patches/kernel.ld \
        /opt/mountin/sources/riscos/RiscOS/Sources/Kernel/kernel.ld && \
    cp /patches/module.ld /opt/rool/module.ld && \
    cp /patches/sharedclib.ld /opt/rool/sharedclib.ld

COPY noscl-runtime.c /build/noscl-runtime.c
COPY --chmod=755 build-noscl-runtime.sh /build/build-noscl-runtime.sh
RUN /build/build-noscl-runtime.sh

COPY --chmod=755 resgen /opt/rool/bin/resgen

ENV ROOL_BIN=/opt/rool/bin \
    PATH=/opt/rool/bin:$PATH
WORKDIR /work
