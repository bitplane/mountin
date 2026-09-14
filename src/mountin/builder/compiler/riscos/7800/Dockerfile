FROM builder/compiler/riscos

ARG MOUNTIN_BUILD_JOBS=1

RUN mkdir -p /opt/gccsdk /opt/mountin/sources/gccsdk

RUN tar --no-same-owner -xzf /host/build/sources/gccsdk-7800.tar.gz \
        -C /opt/mountin/sources/gccsdk --strip-components=1 && \
    mkdir -p /opt/mountin/sources/gccsdk/srcdir.orig && \
    cp /host/build/sources/autoconf-2.64.tar.bz2 \
        /host/build/sources/automake-1.11.1.tar.bz2 \
        /host/build/sources/libtool-2.4.2.tar.gz \
        /host/build/sources/binutils-2.24.tar.bz2 \
        /host/build/sources/gcc-4.7.4.tar.bz2 \
        /host/build/sources/gmp-5.0.1.tar.bz2 \
        /host/build/sources/mpc-1.1.0.tar.gz \
        /host/build/sources/mpfr-3.0.1.tar.bz2 \
        /opt/mountin/sources/gccsdk/srcdir.orig/

COPY --chmod=755 build-toolbox.sh /build-toolbox.sh
COPY asasm-macro-resolution.patch asasm-filename-lookup.patch gcc-sharedclibrary.patch riscostools-host-only.patch /
RUN patch -d /opt/mountin/sources/gccsdk -p1 < /asasm-macro-resolution.patch && \
    patch -d /opt/mountin/sources/gccsdk -p1 < /asasm-filename-lookup.patch && \
    patch -d /opt/mountin/sources/gccsdk -p1 < /gcc-sharedclibrary.patch
RUN /build-toolbox.sh

COPY asasm-export-alias.patch asasm-divide.patch \
     asasm-conditional-call-reloc.patch asasm-relative-data.patch /
RUN patch -d /opt/mountin/sources/gccsdk/riscos/asasm -p1 \
        < /asasm-export-alias.patch && \
    patch -d /opt/mountin/sources/gccsdk/riscos/asasm -p1 \
        < /asasm-divide.patch && \
    patch -d /opt/mountin/sources/gccsdk/riscos/asasm -p1 \
        < /asasm-conditional-call-reloc.patch && \
    patch -d /opt/mountin/sources/gccsdk/riscos/asasm -p1 \
        < /asasm-relative-data.patch && \
    cd /opt/mountin/sources/gccsdk && \
    ./riscos/build-it -f -host-tools-only cross

RUN ln -s /opt/mountin/sources/gccsdk /opt/mountin/source && \
    ln -s /opt/mountin/sources/gccsdk/builddir /opt/mountin/build && \
    ln -s /opt/gccsdk/cross/arm-unknown-riscos /opt/mountin/sysroot

ENV PATH=/opt/gccsdk/cross/bin:$PATH \
    CC=arm-unknown-riscos-gcc \
    AR=arm-unknown-riscos-ar \
    STRIP=arm-unknown-riscos-strip \
    RANLIB=arm-unknown-riscos-ranlib

WORKDIR /work
