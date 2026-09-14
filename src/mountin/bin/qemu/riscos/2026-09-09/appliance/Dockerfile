ARG MOUNTIN_BUILDER
FROM ${MOUNTIN_BUILDER}

RUN apt-get update && apt-get install -y --no-install-recommends python3 \
    && rm -rf /var/lib/apt/lists/*

COPY launcher.GNUmakefile launcher.s /build/
COPY --chmod=755 build.sh verify.py /build/
ENTRYPOINT ["/build/build.sh"]
