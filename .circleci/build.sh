#!/bin/bash
set -ev

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

readonly SCRIPT_NAME=cyber_dojo_start_points_create.sh
readonly SCRIPT_URL=https://raw.githubusercontent.com/cyber-dojo/start-points-base/master/${SCRIPT_NAME}

readonly IMAGE_NAME=cyberdojo/exercises
readonly TMP_DIR=$(mktemp -d /tmp/cyber-dojo-start-points.XXXXXXXXX)

cleanup() { rm -rf ${TMP_DIR} > /dev/null; }
trap cleanup EXIT

cd ${TMP_DIR}
curl -O ${SCRIPT_URL}
chmod 700 ./${SCRIPT_NAME}

./${SCRIPT_NAME} \
    ${IMAGE_NAME} \
    --exercises \
      https://github.com/cyber-dojo/exercises.git
