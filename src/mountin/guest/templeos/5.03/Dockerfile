FROM builder/compiler/templeos/5.03

COPY --chmod=755 build.sh /build/build.sh
COPY build-compiler.HC build-distro.HC build-kernel.HC build-native.HC \
    kernel-config.HC package-distro.HC /build/
ENTRYPOINT ["/build/build.sh"]
