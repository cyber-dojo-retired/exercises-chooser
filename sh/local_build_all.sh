#!/bin/bash
set -e

# Use this when you need to recreate the cyberdojo/exercises:latest
# image locally. Eg after making a local change to starter-base
# you cannot update versioner to its new BASE_SHA because
# there is a versioner test that checks the exercises image named
# in the .env file has a matching BASE_SHA env-var.
# ./local_build_all.sh
# SHA=$(docker run --rm cyberdojo/exercises:latest sh -c 'echo $SHA')
# TAG=${SHA:0:7}
# docker tag cyberdojo/exercises:latest cyberdojo/exercises:${TAG}
# docker push cyberdojo/exercises:latest
# docker push cyberdojo/exercises:${TAG}
#
# and now you can update versioner's .env to
# CYBER_DOJO_EXERCISES=cyberdojo/exercises:${TAG}

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly SHA_VALUE=$(cd "${ROOT_DIR}" && git rev-parse HEAD)

SHA="${SHA_VALUE}" \
  ${ROOT_DIR}/../commander/cyber-dojo start-point create \
    cyberdojo/exercises \
      --exercises \
        https://github.com/cyber-dojo/exercises.git
