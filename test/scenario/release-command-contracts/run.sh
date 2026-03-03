#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

__release_cmd="$(node -p "require('${__root}/package.json').scripts.release")"

function has_token() {
  local token="${1}"
  if [[ "${__release_cmd}" = *"${token}"* ]]; then
    echo "present"
  else
    echo "absent"
  fi
}

function token_index() {
  local token="${1}"
  awk -v haystack="${__release_cmd}" -v needle="${token}" 'BEGIN { print index(haystack, needle) }'
}

echo "no-git-tag-version=$(has_token '--no-git-tag-version')"
echo "explicit-git-tag=$(has_token 'git tag "${VERSION}"')"

__replace_idx="$(token_index 'yarn version:replace')"
__tag_idx="$(token_index 'git tag "${VERSION}"')"
if [[ "${__replace_idx}" -gt 0 ]] && [[ "${__tag_idx}" -gt 0 ]] && [[ "${__replace_idx}" -lt "${__tag_idx}" ]]; then
  echo "version-replace-before-tag=present"
else
  echo "version-replace-before-tag=absent"
fi

__commit_idx="$(token_index 'git commit -m "Release ${VERSION}"')"
if [[ "${__commit_idx}" -gt 0 ]] && [[ "${__tag_idx}" -gt 0 ]] && [[ "${__commit_idx}" -lt "${__tag_idx}" ]]; then
  echo "commit-before-tag=present"
else
  echo "commit-before-tag=absent"
fi
