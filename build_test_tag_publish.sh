#!/bin/bash -Eeu

readonly SH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/sh" && pwd)"
source "${SH_DIR}/versioner_env_vars.sh"
export $(versioner_env_vars)
source "${SH_DIR}/build_images.sh"
source "${SH_DIR}/containers_down.sh"
source "${SH_DIR}/containers_up.sh"
source "${SH_DIR}/image_name.sh"
source "${SH_DIR}/image_sha.sh"
source "${SH_DIR}/test_in_containers.sh"

# - - - - - - - - - - - - - - - - - - - - - - - -
build_test_tag_publish()
{
  build_images
  containers_up "$@"
  test_in_containers "$@"
  containers_down
  tag_the_image
  on_ci_publish_tagged_images
}

# - - - - - - - - - - - - - - - - - - - - - - - -
tag_the_image()
{
  local -r image="$(image_name)"
  local -r sha="$(image_sha)"
  local -r tag="${sha:0:7}"
  docker tag "${image}:latest" "${image}:${tag}"
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci()
{
  [ -n "${CIRCLECI:-}" ]
}

# - - - - - - - - - - - - - - - - - - - - - - - -
on_ci_publish_tagged_images()
{
  if ! on_ci; then
    echo 'not on CI so not publishing tagged images'
    return
  fi
  echo 'on CI so publishing tagged images'
  local -r image="$(image_name)"
  local -r sha="$(image_sha)"
  local -r tag="${sha:0:7}"
  # DOCKER_USER, DOCKER_PASS are in ci context
  echo "${DOCKER_PASS}" | docker login --username "${DOCKER_USER}" --password-stdin
  docker push "${image}:latest"
  docker push "${image}:${tag}"
  docker logout
}

# - - - - - - - - - - - - - - - - - - - - - - - -
build_test_tag_publish "$@"
