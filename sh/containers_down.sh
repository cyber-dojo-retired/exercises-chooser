#!/bin/bash -Eeu

if [ "${ROOT_DIR:-}" == '' ]; then
  readonly ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi
source "${ROOT_DIR}/sh/augmented_docker_compose.sh"

containers_down()
{
  augmented_docker_compose \
    down \
    --remove-orphans \
    --volumes
}
