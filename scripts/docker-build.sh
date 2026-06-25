#!/bin/sh
set -eu

IMAGE="${RUNIX_DOCKER_IMAGE:-runix-system-build}"
ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

docker build -t "$IMAGE" "$ROOT"
