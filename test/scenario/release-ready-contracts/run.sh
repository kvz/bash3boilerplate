#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

__work_tmp="$(mktemp -d "${TMPDIR:-/tmp}/release-ready-contracts-work.XXXXXX")"
__stdout_tmp="$(mktemp "${TMPDIR:-/tmp}/release-ready-contracts-stdout.XXXXXX")"
__stderr_tmp="$(mktemp "${TMPDIR:-/tmp}/release-ready-contracts-stderr.XXXXXX")"

function cleanup_before_exit () {
  rm -rf "${__work_tmp:?}"
  rm -f "${__stdout_tmp:?}" "${__stderr_tmp:?}"
}
trap cleanup_before_exit EXIT

mkdir -p "${__work_tmp}/test"
cp "${__root}/test/release-ready.sh" "${__work_tmp}/test/release-ready.sh"
cp "${__root}/CHANGELOG.md" "${__work_tmp}/CHANGELOG.md"
chmod +x "${__work_tmp}/test/release-ready.sh"

pushd "${__work_tmp}" > /dev/null
git -c init.defaultBranch=main init -q
git config user.name "b3bp-test"
git config user.email "b3bp@example.invalid"
git add CHANGELOG.md test/release-ready.sh
git commit -m "seed" -q
git checkout -q -b feature/test-release-guard

set +o errexit
bash ./test/release-ready.sh > "${__stdout_tmp}" 2> "${__stderr_tmp}"
__rc=$?
set -o errexit
popd > /dev/null

echo "exit=${__rc}"

if [[ -s "${__stdout_tmp}" ]]; then
  echo "stdout=not-empty"
else
  echo "stdout=empty"
fi

if grep -q 'must run from main branch' "${__stderr_tmp}"; then
  echo "branch-guard=present"
else
  echo "branch-guard=absent"
fi
