#!/bin/bash -Eeu

# cyberdojo/service-yaml image lives at
# https://github.com/cyber-dojo/service-yaml

augmented_docker_compose()
{
  cd "${ROOT_DIR}" && cat "./docker-compose.yml" \
    | docker run --rm --interactive cyberdojo/service-yaml \
      exercises-start-points \
    | \
      docker-compose --file - "$@"
}
