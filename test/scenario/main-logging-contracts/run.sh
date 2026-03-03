#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

__stdout_tmp="$(mktemp "${TMPDIR:-/tmp}/main-logging-contracts-stdout.XXXXXX")"
__stderr_tmp="$(mktemp "${TMPDIR:-/tmp}/main-logging-contracts-stderr.XXXXXX")"

function cleanup_before_exit () {
  rm -f "${__stdout_tmp:?}" "${__stderr_tmp:?}"
}
trap cleanup_before_exit EXIT

set +o errexit
env LOG_LEVEL=4 NO_COLOR=true bash "${__root}/main.sh" -f /tmp/x > "${__stdout_tmp}" 2> "${__stderr_tmp}"
__rc=$?
set -o errexit

echo "exit=${__rc}"

if [[ -s "${__stdout_tmp}" ]]; then
  echo "stdout=not-empty"
else
  echo "stdout=empty"
fi

if grep -q '\[     info\]' "${__stderr_tmp}"; then
  echo "info=present"
else
  echo "info=absent"
fi

if grep -q '\[  warning\]' "${__stderr_tmp}"; then
  echo "warning=present"
else
  echo "warning=absent"
fi

if grep -q '\[emergency\]' "${__stderr_tmp}"; then
  echo "emergency=present"
else
  echo "emergency=absent"
fi
