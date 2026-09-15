FROM builder/compiler/riscos/2026-09-09

COPY BCM2835PicoHeadless /build/
COPY resources.GNUmakefile resources.s sharedulib.GNUmakefile sharedulib.s /build/
COPY --chmod=755 build.sh /build/build.sh
ENTRYPOINT ["/build/build.sh"]
