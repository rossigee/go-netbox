#!/usr/bin/env bash

set -euo pipefail

NETBOX_VERSION="$1"
NETBOX_DOCKER_VERSION="$2"

REPO_DIR='/tmp/netbox-docker'

rm -rf "${REPO_DIR}"

git clone https://github.com/netbox-community/netbox-docker.git \
  --config advice.detachedHead=false \
  --branch ${NETBOX_DOCKER_VERSION} \
  --depth=1 \
  --quiet \
  "${REPO_DIR}"

mv "${REPO_DIR}/docker-compose.override.yml.example" "${REPO_DIR}/docker-compose.override.yml"

export VERSION="v${NETBOX_VERSION}"
docker compose --project-directory="${REPO_DIR}" up --detach --quiet-pull

curl --silent http://127.0.0.1:8000/api/docs/?format=openapi > api/openapi.json

docker compose --project-directory="${REPO_DIR}" down