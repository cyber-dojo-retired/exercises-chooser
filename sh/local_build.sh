#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly SHA_VALUE=$(cd "${ROOT_DIR}" && git rev-parse HEAD)

IMAGE_NAME=cyberdojo/exercises

CYBER_DOJO_EXERCISES_PORT=4999 \
SHA="${SHA_VALUE}" \
  ${ROOT_DIR}/../commander/cyber-dojo start-point create \
     ${IMAGE_NAME} \
      --exercises \
        file://${ROOT_DIR}
