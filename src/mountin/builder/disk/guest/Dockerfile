FROM builder/emulator/qemu AS qemu

FROM builder/disk/alpine

RUN apk del cdrkit \
    && apk add --no-cache \
        xorriso

COPY --chmod=755 run-until-marker.sh /usr/local/bin/run-until-marker

COPY --from=qemu /usr/bin/qemu-system-x86_64 /usr/bin/qemu-system-x86_64
COPY --from=qemu /usr/share/qemu/ /usr/share/qemu/
