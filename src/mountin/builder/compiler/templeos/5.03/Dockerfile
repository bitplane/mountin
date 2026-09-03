FROM builder/compiler/aiwnios/2026-02-02

COPY source-build.patch aiwnios-aot-data-heaps.patch aot-import-addends.patch external-register-setters.patch noninteractive-kernel.patch redsea-verification.patch forward-asm-imports.patch enable-sse.patch relocatable-page-tables.patch relocatable-memory-map.patch explicit-iretq.patch explicit-long-mode-entry.patch /tmp/

RUN set -eu; \
    mkdir -p /opt/templeos/source; \
    tar --no-same-owner -xzf /host/build/sources/templeos-5.03.tar.gz \
        -C /opt/templeos/source --strip-components=1; \
    patch -d /opt/templeos/source -p1 < /tmp/source-build.patch

RUN patch -d /opt/templeos/source -p1 < /tmp/aiwnios-aot-data-heaps.patch
RUN patch -d /opt/templeos/source -p1 < /tmp/aot-import-addends.patch
RUN patch -d /opt/templeos/source -p1 < /tmp/external-register-setters.patch
RUN patch -d /opt/templeos/source -p1 < /tmp/noninteractive-kernel.patch
RUN patch -d /opt/templeos/source -p1 < /tmp/forward-asm-imports.patch
RUN patch -d /opt/templeos/source -p1 < /tmp/enable-sse.patch
RUN patch -d /opt/templeos/source -p1 < /tmp/relocatable-page-tables.patch
RUN patch -d /opt/templeos/source -p1 < /tmp/relocatable-memory-map.patch
RUN patch -d /opt/templeos/source -p1 < /tmp/explicit-iretq.patch
RUN patch -d /opt/templeos/source -p1 < /tmp/explicit-long-mode-entry.patch
RUN patch -d /opt/templeos/source -p1 < /tmp/redsea-verification.patch
WORKDIR /work
