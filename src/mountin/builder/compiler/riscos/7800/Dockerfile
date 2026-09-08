FROM builder/compiler/riscos

ARG MOUNTIN_BUILD_JOBS=1

RUN mkdir -p /opt/gccsdk /opt/mountin/source

RUN tar --no-same-owner -xzf /host/build/sources/gccsdk-7800.tar.gz \
        -C /opt/mountin/source --strip-components=1 && \
    mkdir -p /opt/mountin/source/srcdir.orig && \
    cp /host/build/sources/autoconf-2.64.tar.bz2 \
        /host/build/sources/automake-1.11.1.tar.bz2 \
        /host/build/sources/libtool-2.4.2.tar.gz \
        /host/build/sources/binutils-2.24.tar.bz2 \
        /host/build/sources/gcc-4.7.4.tar.bz2 \
        /host/build/sources/gmp-5.0.1.tar.bz2 \
        /host/build/sources/mpc-1.1.0.tar.gz \
        /host/build/sources/mpfr-3.0.1.tar.bz2 \
        /opt/mountin/source/srcdir.orig/

COPY --chmod=755 build-toolbox.sh /build-toolbox.sh
RUN /build-toolbox.sh

RUN ln -s /opt/mountin/source/builddir /opt/mountin/build && \
    ln -s /opt/gccsdk/cross/arm-unknown-riscos /opt/mountin/sysroot

ENV PATH=/opt/gccsdk/cross/bin:$PATH \
    CC=arm-unknown-riscos-gcc \
    AR=arm-unknown-riscos-ar \
    STRIP=arm-unknown-riscos-strip \
    RANLIB=arm-unknown-riscos-ranlib

WORKDIR /work
