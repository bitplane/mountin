FROM builder/compiler/9front

RUN set -eu; \
    mkdir -p /opt/mountin/source /opt/9front; \
    tar -xzf /host/build/sources/9front-11957.tar.gz \
        -C /opt/mountin/source --strip-components=1; \
    gzip -dc /host/build/sources/9front-11957.amd64.qcow2.gz \
        > /opt/9front/bootstrap.qcow2; \
    qemu-img check -f qcow2 /opt/9front/bootstrap.qcow2

COPY --chmod=755 9front-build /usr/local/bin/9front-build
COPY --chmod=755 build.py /usr/local/libexec/9front-build.py

WORKDIR /work
