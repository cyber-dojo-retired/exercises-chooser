#!/bin/bash
set -ev

readonly GITHUB_ORG=https://raw.githubusercontent.com/cyber-dojo
readonly REPO_NAME=starter-base
#readonly REPO_NAME=commander
readonly SCRIPT_NAME=cyber-dojo
readonly TMP_DIR=$(mktemp -d /tmp/cyber-dojo-exercises.XXXXXXXXX)

remove_tmp_dir() { rm -rf ${TMP_DIR} > /dev/null; }
trap remove_tmp_dir EXIT

cd ${TMP_DIR}
curl -O --silent "${GITHUB_ORG}/${REPO_NAME}/master/${SCRIPT_NAME}"
chmod 700 ./${SCRIPT_NAME}

./${SCRIPT_NAME} start-point create \
    cyberdojo/exercises \
      --exercises \
        https://github.com/cyber-dojo/exercises.git
