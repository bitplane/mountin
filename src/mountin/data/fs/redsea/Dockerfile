FROM builder/compiler/aiwnios/2026-02-02

COPY --chmod=755 build.sh /build/build.sh
COPY fixture.HC /build/fixture.HC

ENTRYPOINT ["/build/build.sh"]

