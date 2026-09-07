FROM builder/compiler/aiwnios/2026-02-02

COPY *.patch /tmp/templeos-patches/

RUN set -eu; \
    mkdir -p /opt/mountin/source /opt/mountin/sources /opt/mountin/build; \
    tar --no-same-owner -xzf /host/build/sources/templeos-5.03.tar.gz \
        -C /opt/mountin/source --strip-components=1; \
    for source_patch in /tmp/templeos-patches/*.patch; do \
        patch -d /opt/mountin/source -p1 --fuzz=0 < "$source_patch"; \
    done; \
    rm -r /tmp/templeos-patches; \
    cp -a /opt/aiwnios/source/. /opt/mountin/build/; \
    cp -a /opt/mountin/source/. /opt/mountin/build/; \
    ln -s /opt/aiwnios/source /opt/mountin/sources/aiwnios
WORKDIR /work
