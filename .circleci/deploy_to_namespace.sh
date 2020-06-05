#!/bin/bash -Eeu

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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Normally I export the cyberdojo env-vars using the command
# $ docker run --rm cyberdojo/versioner:latest
# This won't work on the.circleci deployment step since it is
# run inside the cyberdojo/gcloud-kubectl-helm image which does
# not have docker. So doing it directly from versioner's git repo
export $(curl https://raw.githubusercontent.com/cyber-dojo/versioner/master/app/.env)

readonly NAMESPACE="${1}" # eg beta
readonly CYBER_DOJO_EXERCISES_CHOOSER_TAG="${CIRCLE_SHA1:0:7}"

helm_upgrade \
   "${NAMESPACE}" \
   "${CYBER_DOJO_EXERCISES_CHOOSER_IMAGE}" \
   "${CYBER_DOJO_EXERCISES_CHOOSER_TAG}" \
   "${CYBER_DOJO_EXERCISES_CHOOSER_PORT}" \
   ".circleci/k8s-general-values.yml" \
   ".circleci/k8s-specific-values.yml" \
   "exercises-chooser" \
   "praqma/cyber-dojo-service --version 0.2.5"
