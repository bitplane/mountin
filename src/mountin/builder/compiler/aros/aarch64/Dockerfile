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
        --target=raspi-aarch64 \
        --enable-build-type=nightly \
        --enable-ccache \
        --enable-rust \
        --with-binutils-version=2.47 \
        --with-gcc-version=16.2.0 \
        --with-portssources=/host/build/sources/aros-ports \
        --with-aros-toolchain-install="$INSTALL_DIR" \
        --with-optimization="-Os"; \
    make -j1 tools; \
    make -j"${MOUNTIN_BUILD_JOBS}" crosstools; \
    make -j"${MOUNTIN_BUILD_JOBS}" tools-crosstools-rust-check; \
    HOST_TOOLS=bin/linux-${MOUNTIN_BUILD_ARCH}/tools; \
    mkdir -p /opt/aros-toolbox/bin/raspi-aarch64/AROS \
        "/opt/aros-toolbox/$HOST_TOOLS"; \
    cp -a "$BUILD_DIR/bin/raspi-aarch64/AROS/Developer" \
        /opt/aros-toolbox/bin/raspi-aarch64/AROS/; \
    cp -a "$BUILD_DIR/$HOST_TOOLS/collect-aros" \
        "/opt/aros-toolbox/$HOST_TOOLS/"; \
    mkdir -p /opt/mountin/sources/aros-ports \
        /opt/mountin/sources/linux; \
    cp -a "$SOURCE_DIR" /opt/mountin/source; \
    mkdir -p /opt/mountin/sources/rust /opt/mountin/cargo; \
    cp -a "$BUILD_DIR/$HOST_TOOLS/../Ports/host/rust/rustc-1.98.1-src/vendor/libc-0.2.185" \
        /opt/mountin/sources/rust/; \
    printf '%s\n' '[patch.crates-io]' \
        'libc = { path = "/opt/mountin/sources/rust/libc-0.2.185" }' \
        > /opt/mountin/cargo/config.toml; \
    cp /host/build/sources/aros-ports/UnicodeData.txt \
        /host/build/sources/aros-ports/SpecialCasing.txt \
        /host/build/sources/aros-ports/pci.ids \
        /opt/mountin/sources/aros-ports/; \
    for archive in \
        binutils-2.47.tar.bz2 gcc-16.2.0.tar.xz \
        gmp-6.3.0.tar.bz2 isl-0.27.tar.bz2 \
        mpc-1.4.1.tar.xz mpfr-4.2.2.tar.bz2; \
    do \
        name=${archive%.tar.*}; \
        mkdir -p "/opt/mountin/sources/$name"; \
        tar -xf "/host/build/sources/aros-ports/$archive" \
            -C "/opt/mountin/sources/$name" --strip-components=1; \
    done; \
    tar -xf /host/build/sources/linux-6.12.tar.xz \
        -C /opt/mountin/sources/linux --strip-components=1; \
    ln -s /opt/aros-toolbox /opt/mountin/build; \
    ln -s /opt/aros-toolbox/bin/raspi-aarch64/AROS/Developer \
        /opt/mountin/sysroot

RUN set -eu; \
    for archive in \
        acpica-unix-20260408.tar.gz \
        boost_1_89_0.tar.gz \
        bzip2-1.0.8.tar.gz \
        codesets/6.22.tar.gz \
        expat-2.8.2.tar.bz2 \
        freetype-2.14.3.tar.xz \
        glu-9.0.2.tar.xz \
        grub-2.12.tar.gz \
        jpegsrc.v9f.tar.gz \
        libpng-1.6.58.tar.gz \
        mbedtls-3.6.7.tar.bz2 \
        mesa-26.0.0.tar.xz \
        pixman-0.46.4.tar.gz \
        openal-soft-1.19.1.tar.bz2 \
        tiff-4.7.2.tar.xz \
        utf8proc/v2.11.3.tar.gz \
        xz-5.8.3.tar.gz \
        zlib.tar.gz \
        zstd-1.5.7.tar.gz; \
    do \
        destination=/opt/mountin/sources/aros-ports/$archive; \
        mkdir -p "$(dirname "$destination")"; \
        cp "/host/build/sources/aros-ports/$archive" "$destination"; \
    done

COPY --chmod=755 cc.sh /usr/local/bin/aros-cc

RUN ln -s /opt/aros-toolchain/aarch64-aros-ar /usr/local/bin/aros-ar && \
    ln -s /opt/aros-toolchain/aarch64-aros-strip /usr/local/bin/aros-strip

ENV AROS_SYSROOT=/opt/aros-toolbox/bin/raspi-aarch64/AROS/Developer \
    CC=aros-cc \
    AR=aros-ar \
    STRIP=aros-strip \
    PATH=/opt/aros-toolchain/bin:$PATH \
    CARGO_HOME=/opt/mountin/cargo \
    CARGO_BUILD_TARGET=aarch64-unknown-aros \
    CARGO_TARGET_AARCH64_UNKNOWN_AROS_LINKER=aros-cc \
    RUSTFLAGS="-C panic=abort"

WORKDIR /work
