FROM docker.io/library/debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    libsdl2-dev \
    && rm -rf /var/lib/apt/lists/*

