#!/bin/bash -Eeu

readonly SH_DIR="$(cd "$( dirname "${0}")/sh" && pwd)"
"${SH_DIR}/sh/build_docker_images.sh"
exit 42
