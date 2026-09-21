#!/usr/bin/env bash
set -euo pipefail

image=localhost/mountin-test-integration:latest
podman build --ignorefile scripts/test-integration.containerignore -f scripts/Dockerfile.test-integration -t "$image" .
podman run --rm --network none \
    -v "$PWD:/workspace:ro" -w /workspace \
    "$image" python3 -m pytest -p no:cacheprovider -m external_tools tests
