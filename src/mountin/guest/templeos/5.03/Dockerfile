FROM builder/compiler/templeos/5.03

COPY --chmod=755 build.sh /build/build.sh
COPY build-compiler.HC build-distro.HC build-image.HC build-kernel.HC \
    kernel-config.HC kernel-source.HC package-distro.HC /build/
ENTRYPOINT ["/build/build.sh"]
