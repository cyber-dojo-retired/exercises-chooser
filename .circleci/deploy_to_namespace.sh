#!/bin/bash -Eeu

readonly NAMESPACE="${1}" # eg beta

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
TAG="${CIRCLE_SHA1:0:7}"
helm upgrade \
  --install \
  --namespace=${NAMESPACE} \
  --set-string containers[0].tag=${TAG} \
  --values .circleci/exercises-chooser-values.yaml \
  ${NAMESPACE}-exercises-chooser \
  praqma/cyber-dojo-service \
  --version 0.2.4
