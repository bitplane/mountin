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

COPY --chmod=755 build-host-tools.sh /build-host-tools.sh
RUN /build-host-tools.sh

FROM host-tools

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
        --strip-components=1

COPY --chmod=755 resgen /opt/rool/bin/resgen

COPY --chmod=755 build-scl-module.sh /build-scl-module.sh
RUN /build-scl-module.sh

ENV ROOL_BIN=/opt/rool/bin \
    PATH=/opt/rool/bin:$PATH
WORKDIR /work
