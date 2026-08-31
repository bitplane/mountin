FROM docker.io/library/ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    autopoint \
    bison \
    binutils-i686-linux-gnu \
    build-essential \
    ca-certificates \
    clang \
    cmake \
    csh \
    ed \
    flex \
    gawk \
    gcc-i686-linux-gnu \
    gettext \
    git \
    libblocksruntime-dev \
    libc++-14-dev \
    libacl1-dev \
    libbz2-dev \
    liblzma-dev \
    libplist-utils \
    libssl-dev \
    libxml2-dev \
    lld \
    llvm \
    ninja-build \
    perl \
    pkg-config \
    python3 \
    unifdef \
    uuid-dev \
    xz-utils \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

COPY --chmod=755 plutil /usr/bin/plutil

WORKDIR /work
