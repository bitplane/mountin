ARG MOUNTIN_BUILDER
FROM ${MOUNTIN_BUILDER}

COPY --chmod=755 build.sh verify.py /build/
ENTRYPOINT ["/build/build.sh"]
