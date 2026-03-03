#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

echo "ACCPTST:STDIO_REPLACE_DATETIMES"

function run_case() {
  local label="${1}"
  shift
  local output_file
  output_file="$(mktemp "${TMPDIR:-/tmp}/main-longopt-errors.XXXXXX")"

  set +o errexit
  "$@" > "${output_file}" 2>&1
  local rc="${?}"
  set -o errexit

  echo "# ${label}"
  echo "exit: ${rc}"
  grep -E 'Invalid use of script: --|requires an argument|does not take an argument|arg_f:|arg_d:' "${output_file}" \
    | grep -Ev '^\+\(' || true

  rm -f "${output_file}"
}

run_case "unknown-long-option" bash "${__root}/main.sh" --unknown -f /tmp/x
run_case "unknown-long-option-invalid-chars" bash "${__root}/main.sh" --invalid.option -f /tmp/x
run_case "hyphen-prefixed-value" bash "${__root}/main.sh" --file - --debug
run_case "empty-string-value" bash "${__root}/main.sh" -f /tmp/x --temp "" --debug
run_case "missing-value-end-of-input" bash "${__root}/main.sh" --file
run_case "flag-assignment-on-boolean" bash "${__root}/main.sh" -f /tmp/x --debug=true
run_case "double-dash-separator" bash "${__root}/main.sh" -f /tmp/x -- --debug
