#!/bin/bash -Eeu

versioner_env_vars()
{
  docker run --rm cyberdojo/versioner:latest
  echo CYBER_DOJO_CLIENT_PORT=9999
  echo CYBER_DOJO_CLIENT_USER=nobody
  echo CYBER_DOJO_SERVER_USER=nobody
  echo CYBER_DOJO_SERVER_NAME=exercises-chooser
}
