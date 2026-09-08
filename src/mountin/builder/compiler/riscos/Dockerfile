FROM docker.io/library/debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    autogen \
    automake \
    bison \
    build-essential \
    ca-certificates \
    flex \
    gperf \
    help2man \
    libtool \
    m4 \
    patch \
    pkg-config \
    texinfo \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /work
