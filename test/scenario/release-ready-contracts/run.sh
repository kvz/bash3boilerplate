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
__fake_bin="${__work_tmp}/fake-bin"

function cleanup_before_exit () {
  rm -rf "${__work_tmp:?}"
  rm -f "${__stdout_tmp:?}" "${__stderr_tmp:?}"
}
trap cleanup_before_exit EXIT

mkdir -p "${__fake_bin}"

cat > "${__fake_bin}/gh" <<-'EOF'
#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

if [[ "${1:-}" = "auth" ]] && [[ "${2:-}" = "status" ]]; then
  exit 0
fi

if [[ "${1:-}" = "repo" ]] && [[ "${2:-}" = "view" ]]; then
  echo "kvz/bash3boilerplate"
  exit 0
fi

if [[ "${1:-}" = "api" ]]; then
  __path="${2:-}"
  __jq=""
  if [[ "${3:-}" = "--jq" ]]; then
    __jq="${4:-}"
  fi

  case "${__path}" in
    repos/kvz/bash3boilerplate/commits/*/status)
      if [[ "${__jq}" = ".state" ]]; then
        echo "pending"
      else
        echo '{"state":"pending"}'
      fi
      exit 0
      ;;
    repos/kvz/bash3boilerplate/commits/*/check-runs)
      if [[ -n "${__jq}" ]]; then
        if [[ "${__jq}" = *"total_count"* ]]; then
          echo "2"
        else
          echo "0"
        fi
      else
        echo '{"total_count":2,"check_runs":[{"status":"completed","conclusion":"success"},{"status":"completed","conclusion":"success"}]}'
      fi
      exit 0
      ;;
  esac
fi

echo "unsupported gh invocation: $*" 1>&2
exit 1
EOF
chmod +x "${__fake_bin}/gh"

function seed_repo() {
  local repo_dir="${1}"

  mkdir -p "${repo_dir}/test"
  cp "${__root}/test/release-ready.sh" "${repo_dir}/test/release-ready.sh"
  cat > "${repo_dir}/CHANGELOG.md" <<-'EOF'
# Changelog

## main

- [x] test-ready
EOF
  chmod +x "${repo_dir}/test/release-ready.sh"
}

function run_case() {
  local label="${1}"
  local repo_dir="${2}"
  shift 2

  pushd "${repo_dir}" > /dev/null
  set +o errexit
  "$@" > "${__stdout_tmp}" 2> "${__stderr_tmp}"
  __rc=$?
  set -o errexit
  popd > /dev/null

  echo "# ${label}"
  echo "exit=${__rc}"
}

__branch_repo="${__work_tmp}/branch-guard"
seed_repo "${__branch_repo}"
pushd "${__branch_repo}" > /dev/null
git -c init.defaultBranch=main init -q
git config user.name "b3bp-test"
git config user.email "b3bp@example.invalid"
git add CHANGELOG.md test/release-ready.sh
git commit -m "seed" -q
git checkout -q -b feature/test-release-guard
popd > /dev/null

run_case "branch-guard" "${__branch_repo}" bash ./test/release-ready.sh

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

__checks_repo="${__work_tmp}/checks-api"
seed_repo "${__checks_repo}"
pushd "${__checks_repo}" > /dev/null
git -c init.defaultBranch=main init -q
git config user.name "b3bp-test"
git config user.email "b3bp@example.invalid"
git add CHANGELOG.md test/release-ready.sh
git commit -m "seed" -q
popd > /dev/null

run_case "checks-api-success" "${__checks_repo}" env PATH="${__fake_bin}:${PATH}" bash ./test/release-ready.sh

if [[ -s "${__stdout_tmp}" ]]; then
  if grep -q 'release-ready: ok' "${__stdout_tmp}"; then
    echo "stdout-ok=present"
  else
    echo "stdout-ok=absent"
  fi
else
  echo "stdout-ok=absent"
fi
if [[ -s "${__stderr_tmp}" ]]; then
  echo "stderr=not-empty"
else
  echo "stderr=empty"
fi
