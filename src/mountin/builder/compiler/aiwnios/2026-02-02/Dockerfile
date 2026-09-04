FROM builder/compiler/aiwnios

ARG MOUNTIN_BUILD_JOBS
COPY . /tmp/patches/

RUN set -eu; \
    mkdir -p /opt/aiwnios/source /opt/aiwnios/build; \
    tar --no-same-owner -xzf /host/build/sources/aiwnios-2026-02-02.tar.gz \
        -C /opt/aiwnios/source --strip-components=1; \
    while IFS= read -r patch_file; do \
        patch --fuzz=0 --forward -d /opt/aiwnios/source -p1 \
            < "/tmp/patches/$patch_file"; \
    done < /tmp/patches/series; \
    cmake -S /opt/aiwnios/source -B /opt/aiwnios/build \
        -DCMAKE_BUILD_TYPE=Debug; \
    SDL_VIDEODRIVER=dummy SDL_AUDIODRIVER=dummy \
        cmake --build /opt/aiwnios/build -j"${MOUNTIN_BUILD_JOBS}" \
            --target HCRT2.BIN; \
    test -s /opt/aiwnios/source/HCRT2.BIN; \
    ln -s /opt/aiwnios/source/aiwnios /usr/local/bin/aiwnios

WORKDIR /work
