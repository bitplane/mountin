FROM docker.io/library/debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    bash \
    bison \
    build-essential \
    bzip2 \
    coreutils \
    diffutils \
    findutils \
    flex \
    gawk \
    gettext \
    groff \
    grep \
    gzip \
    libncurses-dev \
    libtool \
    patch \
    perl \
    python3 \
    sed \
    tar \
    texinfo \
    xz-utils \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work
