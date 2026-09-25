ARG MOUNTIN_BUILDER
FROM ${MOUNTIN_BUILDER}

ARG MOUNTIN_BUILD_ARCH
ARG MOUNTIN_BUILD_JOBS=1
ARG MOUNTIN_CACHE_DIR
ENV TAR_OPTIONS=--no-same-owner

RUN set -eu; \
    SOURCE_ARCHIVE=/host/build/sources/aros-2026-09-24.tar.gz; \
    CACHE_DIR=$MOUNTIN_CACHE_DIR; \
    SOURCE_DIR=$CACHE_DIR/source; \
    BUILD_DIR=$CACHE_DIR/toolchain-build; \
    INSTALL_DIR=/opt/aros-toolchain; \
    export CCACHE_DIR=$CACHE_DIR/ccache; \
    mkdir -p "$CACHE_DIR" "$CCACHE_DIR" "$INSTALL_DIR"; \
    if [ ! -d "$SOURCE_DIR" ]; then \
        TEMPORARY=$CACHE_DIR/source.tmp.$$; \
        rm -rf "$TEMPORARY"; \
        mkdir -p "$TEMPORARY"; \
        tar --no-same-owner -xzf "$SOURCE_ARCHIVE" \
            -C "$TEMPORARY" --strip-components=1; \
        mv "$TEMPORARY" "$SOURCE_DIR"; \
    fi; \
    mkdir -p "$BUILD_DIR" "$INSTALL_DIR"; \
    cd "$BUILD_DIR"; \
    "$SOURCE_DIR/configure" \
        --target=amiga-m68k \
        --enable-build-type=nightly \
        --enable-ccache \
        --with-binutils-version=2.32 \
        --with-gcc-version=6.5.0 \
        --with-portssources=/host/build/sources/aros-ports \
        --with-aros-toolchain-install="$INSTALL_DIR" \
        --with-optimization="-Os"; \
    make -j1 tools; \
    make -j"${MOUNTIN_BUILD_JOBS}" crosstools; \
    HOST_TOOLS=bin/linux-${MOUNTIN_BUILD_ARCH}/tools; \
    mkdir -p \
        /opt/aros-toolbox/bin/amiga-m68k/AROS \
        "/opt/aros-toolbox/$HOST_TOOLS"; \
    cp -a \
        "$BUILD_DIR/bin/amiga-m68k/AROS/Developer" \
        /opt/aros-toolbox/bin/amiga-m68k/AROS/; \
    cp -a \
        "$BUILD_DIR/$HOST_TOOLS/collect-aros" \
        "/opt/aros-toolbox/$HOST_TOOLS/"; \
    mkdir -p /opt/mountin/sources/aros-ports; \
    cp -a "$SOURCE_DIR" /opt/mountin/source; \
    cp /host/build/sources/aros-ports/UnicodeData.txt \
        /host/build/sources/aros-ports/SpecialCasing.txt \
        /opt/mountin/sources/aros-ports/; \
    for archive in \
        binutils-2.32.tar.bz2 gcc-6.5.0.tar.xz \
        gmp-6.3.0.tar.bz2 isl-0.25.tar.bz2 \
        mpc-1.4.1.tar.xz mpfr-4.2.2.tar.bz2; \
    do \
        name=${archive%.tar.*}; \
        mkdir -p "/opt/mountin/sources/$name"; \
        tar -xf "/host/build/sources/aros-ports/$archive" \
            -C "/opt/mountin/sources/$name" --strip-components=1; \
    done; \
    ln -s /opt/aros-toolbox /opt/mountin/build; \
    ln -s /opt/aros-toolbox/bin/amiga-m68k/AROS/Developer \
        /opt/mountin/sysroot

COPY --chmod=755 cc.sh /usr/local/bin/aros-cc

RUN ln -s /opt/aros-toolchain/m68k-aros-ar /usr/local/bin/aros-ar && \
    ln -s /opt/aros-toolchain/m68k-aros-strip /usr/local/bin/aros-strip

ENV AROS_SYSROOT=/opt/aros-toolbox/bin/amiga-m68k/AROS/Developer \
    CC=aros-cc \
    AR=aros-ar \
    STRIP=aros-strip \
    PATH=/opt/aros-toolchain/bin:$PATH

WORKDIR /work
