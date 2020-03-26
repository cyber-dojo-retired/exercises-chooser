#!/bin/bash -Eeu

# Setting --project-name is required to ensure it is
# not custom-chooser (default from the root dir)
# which would be the same as the main docker-compose.yml
# service-name and would prevent .sh scripts which obtain
# the container-name from the service-name from working.
# See sh/container_info.sh
#
# The initial change-directory command is needed because
# the current working directory is taken as the dir for
# relative pathnames (eg in volume-mounts) when the
# yml is received from stdin (--file -).

if [ "${ROOT_DIR:-}" == '' ]; then
  readonly ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi

augmented_docker_compose()
{
  cd "${ROOT_DIR}" && cat "./docker-compose.yml" \
    | docker run --rm --interactive cyberdojo/service-yaml \
             exercises-chooser \
           custom-start-points \
        exercises-start-points \
        languages-start-points \
                       creator \
                         saver \
                      selenium \
    | tee /tmp/augmented-docker-compose.peek.yml \
    | docker-compose \
        --project-name cyber-dojo \
        --file -                  \
        "$@"
}
