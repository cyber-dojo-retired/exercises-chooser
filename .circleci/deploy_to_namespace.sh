#!/bin/bash -Eeu

readonly SH_DIR="$(cd "$(dirname "${0}")/../sh" && pwd)"
source ${SH_DIR}/versioner_env_vars.sh
echo '---------------------'
versioner_env_vars
echo '---------------------'
export $(versioner_env_vars)
echo '~~~~~~~~~~~~~~~~~~~~~'
env
echo '~~~~~~~~~~~~~~~~~~~~~'

readonly NAMESPACE="${1}" # eg beta
readonly IMAGE="${CYBER_DOJO_EXERCISES_CHOOSER_IMAGE}"
readonly PORT="${CYBER_DOJO_EXERCISES_CHOOSER_PORT}"
readonly TAG="${CIRCLE_SHA1:0:7}"

# misc env-vars are in ci context

echo ${GCP_K8S_CREDENTIALS} > /gcp/gcp-credentials.json

gcloud auth activate-service-account \
  "${SERVICE_ACCOUNT}" \
  --key-file=/gcp/gcp-credentials.json

gcloud container clusters get-credentials \
  "${CLUSTER}" \
  --zone "${ZONE}" \
  --project "${PROJECT}"

helm init --client-only

helm repo add praqma https://praqma-helm-repo.s3.amazonaws.com/

helm upgrade \
  --install \
  --namespace=${NAMESPACE} \
  --set-string containers[0].image=${IMAGE} \
  --set-string containers[0].tag=${TAG} \
  --set service.port=${PORT} \
  --set containers[0].livenessProbe.port=${PORT} \
  --set containers[0].readinessProbe.port=${PORT} \
  --values .circleci/exercises-chooser-values.yaml \
  ${NAMESPACE}-exercises-chooser \
  praqma/cyber-dojo-service \
  --version 0.2.4
