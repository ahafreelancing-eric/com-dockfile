#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${1:-ubuntu22-dev-ai:linux-amd64}"

if ! docker buildx version >/dev/null 2>&1; then
  echo "docker buildx is required to build a linux/amd64 image on non-amd64 hosts." >&2
  echo "Install the Docker Buildx plugin, then run this script again." >&2
  exit 1
fi

docker buildx build \
  --platform linux/amd64 \
  -t "${IMAGE_NAME}" \
  --load \
  .
