#!/bin/bash -Eeu

readonly NAMESPACE="${1}" # beta|prod
readonly K8S_URL=https://raw.githubusercontent.com/cyber-dojo/k8s-install/master
readonly VERSIONER_URL=https://raw.githubusercontent.com/cyber-dojo/versioner/master
source <(curl "${K8S_URL}/sh/deployment_functions.sh")
export $(curl "${VERSIONER_URL}/app/.env")
readonly CYBER_DOJO_EXERCISES_CHOOSER_TAG="${CIRCLE_SHA1:0:7}"

gcloud_init
helm_init
helm_upgrade_probe_yes_prometheus_yes \
   "${NAMESPACE}" \
   "exercises-chooser" \
   "${CYBER_DOJO_EXERCISES_CHOOSER_IMAGE}" \
   "${CYBER_DOJO_EXERCISES_CHOOSER_TAG}" \
   "${CYBER_DOJO_EXERCISES_CHOOSER_PORT}" \
   ".circleci/k8s-general-values.yml"
