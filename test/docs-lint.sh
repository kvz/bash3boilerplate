#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

files=(
  "README.md"
  "FAQ.md"
)

failed=0

function check_pattern() {
  local pattern="${1}"
  local message="${2}"
  local matches=""

  matches="$(grep -nE "${pattern}" "${files[@]}" || true)"
  if [[ -n "${matches}" ]]; then
    echo "docs-lint: ${message}" 1>&2
    echo "${matches}" 1>&2
    failed=1
  fi
}

# Avoid stale CI references that have historically drifted.
check_pattern 'travis-ci\.org' "legacy Travis CI links are not allowed"

# Avoid pinning docs to historical tagged line links that go stale quickly.
check_pattern 'github\.com/[^ )]+/blob/v[0-9]+\.[0-9]+\.[0-9]+/[^ )]*#L[0-9]+' "version-pinned GitHub line links are not allowed"

# Avoid line-number anchors even on moving branches, as line numbers are brittle.
check_pattern 'github\.com/[^ )]+/blob/(HEAD|main)/[^ )]*#L[0-9]+' "GitHub line-number anchors are not allowed; link to behavior sections instead"

if [[ "${failed}" = "1" ]]; then
  exit 1
fi

echo "docs-lint: ok"
