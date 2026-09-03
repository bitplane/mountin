FROM builder/compiler/aiwnios/2026-02-02

RUN set -eu; \
    mkdir -p /opt/templeos/source; \
    tar --no-same-owner -xzf /host/build/sources/templeos-5.03.tar.gz \
        -C /opt/templeos/source --strip-components=1
WORKDIR /work
