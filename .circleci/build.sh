#!/bin/bash
set -ev

readonly GITHUB_ORG=https://raw.githubusercontent.com/cyber-dojo
readonly CREATE_IMAGE_SCRIPT=cyber_dojo_start_points_create.sh
readonly IMAGE_NAME=cyberdojo/exercises
readonly TMP_DIR=$(mktemp -d /tmp/cyber-dojo-exercises.XXXXXXXXX)

cleanup() { rm -rf ${TMP_DIR} > /dev/null; }
trap cleanup EXIT

cd ${TMP_DIR}
curl -O "${GITHUB_ORG}/start-points-base/master/${CREATE_IMAGE_SCRIPT}"
chmod 700 ./${CREATE_IMAGE_SCRIPT}

./${CREATE_IMAGE_SCRIPT} \
    ${IMAGE_NAME} \
    --exercises \
      https://github.com/cyber-dojo/exercises.git
