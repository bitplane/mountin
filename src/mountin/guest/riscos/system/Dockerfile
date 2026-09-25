FROM builder/compiler/riscos/system

COPY BCM2835PicoHeadless /build/
COPY resources.GNUmakefile resources.s sharedulib.GNUmakefile sharedulib.s /build/
COPY --chmod=755 build.sh /build/build.sh
ENTRYPOINT ["/build/build.sh"]
