FROM builder/compiler/aiwnios/2026-02-02

COPY *.patch /tmp/templeos-patches/

RUN set -eu; \
    mkdir -p /opt/templeos/source; \
    tar --no-same-owner -xzf /host/build/sources/templeos-5.03.tar.gz \
        -C /opt/templeos/source --strip-components=1; \
    for source_patch in /tmp/templeos-patches/*.patch; do \
        patch -d /opt/templeos/source -p1 --fuzz=0 < "$source_patch"; \
    done; \
    rm -r /tmp/templeos-patches
WORKDIR /work
