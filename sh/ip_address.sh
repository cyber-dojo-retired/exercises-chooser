#!/bin/bash -Ee

ip_address()
{
  if [ ! -z "${DOCKER_MACHINE_NAME}" ]; then
    docker-machine ip "${DOCKER_MACHINE_NAME}"
  else
    echo localhost
  fi
}
