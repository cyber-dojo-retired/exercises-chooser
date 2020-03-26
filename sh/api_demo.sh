#!/bin/bash -Eeu

readonly SH_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )"
source "${SH_DIR}/build_images.sh"
source "${SH_DIR}/containers_down.sh"
source "${SH_DIR}/containers_up.sh"
source "${SH_DIR}/ip_address.sh"

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
api_demo()
{
  build_images
  containers_up api-demo
  echo
  demo
  echo
  if [ "${1:-}" == '--no-browser' ]; then
    containers_down
  else
    open "http://${IP_ADDRESS}:80/exercises-chooser/group_choose"
  fi
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
demo()
{
  echo API
  curl_json_body_200 GET  alive
  curl_json_body_200 GET  ready
  curl_json_body_200 GET  sha
  echo
  curl_200           GET  assets/app.css 'Content-Type: text/css'
  echo
  curl_200           GET  group_choose create
  curl_200           GET  kata_choose  create
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_json_body_200()
{
  local -r type="${1}"  # eg GET
  local -r route="${2}" # eg alive
  curl  \
    --data "" \
    --fail \
    --header 'Content-type: application/json' \
    --header 'Accept: application/json' \
    --request "${type}" \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 200 "$(log_filename)" # eg HTTP/1.1 200 OK
  local -r result=$(tail -n 1 "$(log_filename)" | head -n 1)
  echo "$(tab)${type} ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
curl_200()
{
  local -r type="${1}"    # eg GET
  local -r route="${2}"   # eg group_choose
  local -r pattern="${3}" # eg exercise
  curl  \
    --fail \
    --request "${type}" \
    --silent \
    --verbose \
      "http://${IP_ADDRESS}:$(port)/${route}" \
      > "$(log_filename)" 2>&1

  grep --quiet 200 "$(log_filename)" # eg HTTP/1.1 200 OK
  local -r result=$(grep "${pattern}" "$(log_filename)" | head -n 1)
  echo "$(tab)${type} ${route} => 200 ${result}"
}

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
port() { echo -n "${CYBER_DOJO_EXERCISES_CHOOSER_PORT}"; }
tab() { printf '\t'; }
log_filename() { echo -n /tmp/exercises-chooser.log ; }

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
api_demo "$@"
