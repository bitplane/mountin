FROM builder/disk/guest

COPY --chmod=755 build.sh verify.py /build/
COPY partition.sfdisk /build/
ENTRYPOINT ["/build/build.sh"]
