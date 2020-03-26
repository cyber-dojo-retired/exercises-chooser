#!/bin/bash -Eeu

readonly root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "${root_dir}/sh/container_info.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - -
test_in_containers()
{
  local -r client_user="${CYBER_DOJO_CLIENT_USER}"
  local -r server_user="${CYBER_DOJO_SERVER_USER}"
  if on_ci; then
    docker pull cyberdojo/check-test-results:latest
  fi
  if [ "${1:-}" == 'client' ]; then
    shift
    run_tests "${client_user}" client "${@:-}"
  elif [ "${1:-}" == 'server' ]; then
    shift
    run_tests "${server_user}" server "${@:-}"
  else
    run_tests "${client_user}" client "${@:-}"
    run_tests "${server_user}" server "${@:-}"
  fi
  echo All passed
}

# - - - - - - - - - - - - - - - - - - - - - - - - - -
on_ci() { [ -n "${CIRCLECI:-}" ]; }

# - - - - - - - - - - - - - - - - - - - - - - - - - -
run_tests()
{
  local -r user="${1}" # eg nobody
  local -r type="${2}" # eg client|server
  local -r reports_dir_name=reports
  local -r tmp_dir=/tmp # fs is read-only with tmpfs at /tmp
  local -r coverage_root=/${tmp_dir}/${reports_dir_name}
  local -r test_dir="${root_dir}/test/${type}"
  local -r reports_dir=${test_dir}/${reports_dir_name}
  local -r test_log=test.log
  local -r coverage_code_tab_name=tested
  local -r coverage_test_tab_name=tester

  if [ "${type}" == 'client' ]; then
    local -r container_name="$(service_container client)"
  else # server
    local -r container_name="$(service_container ${CYBER_DOJO_SERVER_NAME})"
  fi

  echo
  echo '=================================='
  echo "Running ${type} tests"
  echo '=================================='

  # Remove old copies of files we are about to create
  rm ${tmp_dir}/${test_log} 2> /dev/null || true
  rm ${tmp_dir}/index.html  2> /dev/null || true

  set +e
  docker exec \
    --env COVERAGE_CODE_TAB_NAME=${coverage_code_tab_name} \
    --env COVERAGE_TEST_TAB_NAME=${coverage_test_tab_name} \
    --user "${user}" \
    "${container_name}" \
      sh -c "/test/run.sh ${coverage_root} ${test_log} ${type} ${*:3}"
  set -e

  # You can't [docker cp] from a tmpfs, so tar-piping coverage out
  docker exec \
    "${container_name}" \
    tar Ccf \
      "$(dirname "${coverage_root}")" \
      - "$(basename "${coverage_root}")" \
        | tar Cxf "${test_dir}/" -

  set +e
  docker run \
    --env COVERAGE_CODE_TAB_NAME=${coverage_code_tab_name} \
    --env COVERAGE_TEST_TAB_NAME=${coverage_test_tab_name} \
    --rm \
    --volume ${reports_dir}/${test_log}:${tmp_dir}/${test_log}:ro \
    --volume ${reports_dir}/index.html:${tmp_dir}/index.html:ro \
    --volume ${test_dir}/metrics.rb:/app/metrics.rb:ro \
    cyberdojo/check-test-results:latest \
    sh -c "ruby /app/check_test_results.rb ${tmp_dir}/${test_log} ${tmp_dir}/index.html" \
      | tee -a ${reports_dir}/${test_log}
  local -r status=${PIPESTATUS[0]}
  set -e

  local -r coverage_path="${reports_dir}/index.html"
  echo "${type} test coverage at ${coverage_path}"
  echo "${type} test status == ${status}"
  if [ "${status}" != '0' ]; then
    docker logs "${container_name}"
  fi
  return ${status}
}
