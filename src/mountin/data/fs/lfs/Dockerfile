FROM builder/emulator/qemu AS qemu

FROM builder/disk/netbsd

RUN apt-get update && \
    apt-get install -y --no-install-recommends python3 && \
    rm -rf /var/lib/apt/lists/*

COPY --chmod=755 buildfs.sh run.py /build/

COPY --from=qemu /usr/bin/qemu-system-x86_64 /usr/bin/qemu-system-x86_64
COPY --from=qemu /usr/share/qemu/ /usr/share/qemu/
