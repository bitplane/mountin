FROM builder/compiler/templeos/5.03

COPY --chmod=755 build.sh /build/build.sh
COPY build-distro.HC build-kernel.HC kernel-config.HC package-distro.HC /build/
ENTRYPOINT ["/build/build.sh"]
