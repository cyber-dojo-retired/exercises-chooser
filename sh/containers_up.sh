#!/bin/bash -Eeu

readonly ROOT_DIR="$(cd "$(dirname "${0}")/.." && pwd)"
source "${ROOT_DIR}/sh/augmented_docker_compose.sh"
source "${ROOT_DIR}/sh/ip_address.sh"
readonly IP_ADDRESS=$(ip_address) # slow
export NO_PROMETHEUS=true

# - - - - - - - - - - - - - - - - - - - - - -
wait_briefly_until_ready()
{
  local -r port="${1}"
  local -r name="${2}"
  local -r container_name="test-${name}"
  local -r max_tries=40
  printf "Waiting until ${name} is ready"
  for _ in $(seq ${max_tries}); do
    if curl_ready ${port}; then
      printf '.OK\n'
      return
    else
      printf .
      sleep 0.1
    fi
  done
  printf 'FAIL\n'
  printf "${name} not ready after ${max_tries} tries\n"
  if [ -f "$(ready_filename)" ]; then
    printf "$(ready_response)\n"
  else
    printf "$(ready_filename) does not exist?!\n"
  fi
  docker logs ${container_name}
  exit 42
}

# - - - - - - - - - - - - - - - - - - -
curl_ready()
{
  local -r port="${1}"
  local -r path=ready?
  local -r url="http://${IP_ADDRESS}:${port}/${path}"
  rm -f $(ready_filename)
  curl \
    --fail \
    --output $(ready_filename) \
    --request GET \
    --silent \
    "${url}"

  [ "$?" == '0' ] && [ "$(ready_response)" == '{"ready?":true}' ]
}

# - - - - - - - - - - - - - - - - - - -
ready_response()
{
  cat "$(ready_filename)"
}

# - - - - - - - - - - - - - - - - - - -
ready_filename()
{
  printf /tmp/curl-exercises-chooser-ready-output
}

# - - - - - - - - - - - - - - - - - - -
strip_known_warning()
{
  local -r log="${1}"
  local -r known_warning="${2}"
  local stripped=$(printf "${log}" | grep --invert-match -E "${known_warning}")
  if [ "${log}" != "${stripped}" ]; then
    >&2 echo "SERVICE START-UP WARNING: ${known_warning}"
  else
    >&2 echo "DID _NOT_ FIND WARNING!!: ${known_warning}"
  fi
  echo "${stripped}"
}

# - - - - - - - - - - - - - - - - - - -
exit_if_unclean()
{
  local -r container_name="${1}"
  local log=$(docker logs "${container_name}" 2>&1)

  local -r mismatched_indent_warning="application(.*): warning: mismatched indentations at 'rescue' with 'begin'"
  log=$(strip_known_warning "${log}" "${mismatched_indent_warning}")

  printf "Checking ${container_name} started cleanly..."
  local -r line_count=$(echo -n "${log}" | grep -c '^')
  # 3 lines on Thin (Unicorn=6, Puma=6)
  #Thin web server (v1.7.2 codename Bachmanity)
  #Maximum connections set to 1024
  #Listening on 0.0.0.0:4535, CTRL+C to stop
  if [ "${line_count}" == '3' ]; then
    printf 'OK\n'
  else
    printf 'FAIL\n'
    print_docker_log "${container_name}" "${log}"
    exit 42
  fi
}

# - - - - - - - - - - - - - - - - - - -
print_docker_log()
{
  local -r container_name="${1}"
  local -r log="${2}"
  printf "[docker logs ${container_name}]\n"
  printf '<docker_log>\n'
  printf "${log}\n"
  printf '</docker_log>\n'
}

# - - - - - - - - - - - - - - - - - - -
container_up_ready_and_clean()
{
  local -r port="${1}"
  local -r service_name="${2}"
  local -r container_name="test-${service_name}"
  container_up "${port}" "${service_name}"
  wait_briefly_until_ready "${port}" "${container_name}"
  exit_if_unclean "${container_name}"
}

# - - - - - - - - - - - - - - - - - - -
container_up()
{
  local -r port="${1}"
  local -r service_name="${2}"
  local -r container_name="test-${service_name}"
  printf '\n'
  augmented_docker_compose \
    up \
    --detach \
    --force-recreate \
      "${service_name}"
}

# - - - - - - - - - - - - - - - - - - -

if [ "${1:-}" == 'api-demo' ]; then
  container_up 80 nginx
  wait_briefly_until_ready ${CYBER_DOJO_EXERCISES_CHOOSER_PORT} exercises-chooser-server
fi

if [ "${1:-}" == 'server' ]; then
  container_up_ready_and_clean ${CYBER_DOJO_EXERCISES_CHOOSER_PORT} exercises-chooser-server
else
  container_up 80 nginx
  container_up_ready_and_clean ${CYBER_DOJO_EXERCISES_CHOOSER_CLIENT_PORT} exercises-chooser-client
fi
