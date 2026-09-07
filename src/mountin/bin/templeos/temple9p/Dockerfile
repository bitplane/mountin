ARG MOUNTIN_BUILDER
FROM ${MOUNTIN_BUILDER}

COPY --chmod=755 build.sh /build/build.sh
COPY check.HC /build/check.HC
ENTRYPOINT ["/build/build.sh"]
