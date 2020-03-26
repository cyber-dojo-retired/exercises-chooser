#!/bin/bash -Eeu

if [ "${ROOT_DIR:-}" == '' ]; then
  readonly ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi
source "${ROOT_DIR}/sh/augmented_docker_compose.sh"
source "${ROOT_DIR}/sh/container_info.sh"
source "${ROOT_DIR}/sh/ip_address.sh"
export NO_PROMETHEUS=true

# - - - - - - - - - - - - - - - - - - -
containers_up()
{
  if [ "${1:-}" == 'server' ]; then
    top_container_up ${CYBER_DOJO_SERVER_NAME}
    wait_until_ready ${CYBER_DOJO_SERVER_NAME}
    exit_if_unclean  ${CYBER_DOJO_SERVER_NAME}
  else
    top_container_up nginx
    wait_until_ready nginx
    wait_until_ready client
    exit_if_unclean  client
  fi
}

# - - - - - - - - - - - - - - - - - - -
top_container_up()
{
  local -r service_name="${1}"
  printf '\n'
  augmented_docker_compose \
    up \
    --detach \
    --force-recreate \
      "${service_name}"
}

# - - - - - - - - - - - - - - - - - - - - - -
wait_until_ready()
{
  local -r service_name="${1}"
  local -r port="$(service_port ${service_name})"
  local -r container_name=$(service_container ${service_name})
  local -r max_tries=40
  printf "Waiting until ${service_name} is ready"
  for _ in $(seq ${max_tries}); do
    if curl_ready "${service_name}" "${port}"; then
      printf '.OK\n\n'
      docker logs "${container_name}"
      return
    else
      printf .
      sleep 0.1
    fi
  done
  printf 'FAIL\n'
  printf "${service_name} not ready after ${max_tries} tries\n"
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
  local -r service_name="${1}"
  local -r port="${2}"
  local -r path=$([ "${service_name}" == 'nginx' ] && echo 'sha.txt' || echo 'ready?')

  rm -f $(ready_filename)
  curl \
    --fail \
    --output $(ready_filename) \
    --request GET \
    --silent \
    "http://${IP_ADDRESS}:${port}/${path}"

  local -r status=$?
  if [ "${service_name}" == 'nginx' ]; then
    [ "${status}" == '0' ]
    return
  else
    [ "${status}" == '0' ] && [ "$(ready_response)" == '{"ready?":true}' ]
    return
  fi
}

# - - - - - - - - - - - - - - - - - - -
ready_response() { cat "$(ready_filename)"; }
ready_filename() { printf /tmp/curl-exercises-chooser-ready-output; }

# - - - - - - - - - - - - - - - - - - -
exit_if_unclean()
{
  local -r service_name="${1}"
  local -r container_name=$(service_container ${service_name})

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
print_docker_log()
{
  local -r container_name="${1}"
  local -r log="${2}"
  printf "[docker logs ${container_name}]\n"
  printf '<docker_log>\n'
  printf "${log}\n"
  printf '</docker_log>\n'
}
