FROM builder/compiler/templeos/5.03

COPY --chmod=755 build.sh /build/build.sh
COPY build-distro.HC /build/build-distro.HC
ENTRYPOINT ["/build/build.sh"]
