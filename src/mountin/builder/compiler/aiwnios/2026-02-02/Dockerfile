FROM builder/compiler/aiwnios

ARG MOUNTIN_BUILD_JOBS
COPY source-drive.patch /tmp/source-drive.patch

RUN set -eu; \
    mkdir -p /opt/aiwnios/source /opt/aiwnios/build; \
    tar --no-same-owner -xzf /host/build/sources/aiwnios-2026-02-02.tar.gz \
        -C /opt/aiwnios/source --strip-components=1; \
    patch -d /opt/aiwnios/source -p1 < /tmp/source-drive.patch; \
    cmake -S /opt/aiwnios/source -B /opt/aiwnios/build \
        -DCMAKE_BUILD_TYPE=Release; \
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy \
        cmake --build /opt/aiwnios/build -j"${MOUNTIN_BUILD_JOBS}"; \
    ln -s /opt/aiwnios/source/aiwnios /usr/local/bin/aiwnios

WORKDIR /work
