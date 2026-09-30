FROM builder/emulator/qemu AS qemu

FROM docker.io/debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    dosfstools \
    genisoimage \
    gzip \
    mtools \
    python3 \
    python3-pexpect \
    u-boot-qemu \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

COPY --from=qemu /usr/bin/qemu-system-x86_64 /usr/bin/qemu-system-x86_64
COPY --from=qemu /usr/bin/qemu-system-aarch64 /usr/bin/qemu-system-aarch64
COPY --from=qemu /usr/bin/qemu-img /usr/bin/qemu-img
COPY --from=qemu /usr/share/qemu/ /usr/share/qemu/
