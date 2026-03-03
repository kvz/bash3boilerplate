#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"
__stdout_tmp="$(mktemp "${TMPDIR:-/tmp}/parse-url-robust-stdout.XXXXXX")"
__stderr_tmp="$(mktemp "${TMPDIR:-/tmp}/parse-url-robust-stderr.XXXXXX")"

function cleanup_before_exit () {
  rm -f "${__stdout_tmp:?}" "${__stderr_tmp:?}"
}
trap cleanup_before_exit EXIT

# shellcheck source=src/parse_url.sh
source "${__root}/src/parse_url.sh"

echo "# no-proto-with-path"
echo "host=$(parse_url 'example.com/path/to/resource' host)"
echo "path=$(parse_url 'example.com/path/to/resource' path)"

echo "# https-default-port"
echo "port=$(parse_url 'https://example.com' port)"

echo "# redis-default-port"
echo "port=$(parse_url 'redis://cache.internal' port)"

echo "# user-without-pass"
echo "user=$(parse_url 'ssh://jane@example.org' user)"
echo "pass=$(parse_url 'ssh://jane@example.org' pass)"

echo "# explicit-port-no-path"
echo "host=$(parse_url 'http://api.example.org:9000' host)"
echo "port=$(parse_url 'http://api.example.org:9000' port)"
echo "path=$(parse_url 'http://api.example.org:9000' path)"

echo "# unknown-selector"
set +o errexit
parse_url 'https://example.org' bogus > "${__stdout_tmp}" 2> "${__stderr_tmp}"
__rc=$?
set -o errexit
echo "exit=${__rc}"
if [[ -s "${__stdout_tmp}" ]]; then
  echo "stdout=not-empty"
else
  echo "stdout=empty"
fi
if grep -q 'unknown field selector' "${__stderr_tmp}"; then
  echo "selector-guard=present"
else
  echo "selector-guard=absent"
fi
