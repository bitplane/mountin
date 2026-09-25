FROM builder/compiler/aiwnios/toolbox

COPY --chmod=755 build.sh /build/build.sh
COPY fixture.HC /build/fixture.HC

ENTRYPOINT ["/build/build.sh"]

