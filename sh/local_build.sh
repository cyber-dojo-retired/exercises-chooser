#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

${MY_DIR}/../commander/cyber-dojo start-point create \
    cyberdojo/exercises \
      --exercises \
    file://${MY_DIR}
