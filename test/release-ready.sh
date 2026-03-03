#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

function fail() {
  echo "release-ready: $*" 1>&2
  exit 1
}

[[ -f CHANGELOG.md ]] || fail "CHANGELOG.md not found"

branch="$(git rev-parse --abbrev-ref HEAD)"
[[ "${branch}" = "main" ]] || fail "must run from main branch (current: ${branch})"

git diff --quiet || fail "working tree has unstaged changes"
git diff --cached --quiet || fail "working tree has staged but uncommitted changes"

command -v gh > /dev/null || fail "GitHub CLI (gh) is required"
gh auth status > /dev/null 2>&1 || fail "gh is not authenticated"

origin_url="$(git config --get remote.origin.url || true)"
[[ -n "${origin_url}" ]] || fail "remote.origin.url is not configured"

repo_slug=""
if [[ "${origin_url}" = git@github.com:* ]]; then
  repo_slug="${origin_url#git@github.com:}"
elif [[ "${origin_url}" = https://github.com/* ]]; then
  repo_slug="${origin_url#https://github.com/}"
elif [[ "${origin_url}" = http://github.com/* ]]; then
  repo_slug="${origin_url#http://github.com/}"
else
  fail "unsupported remote format for origin: ${origin_url}"
fi
repo_slug="${repo_slug%.git}"
[[ -n "${repo_slug}" ]] || fail "unable to parse repository slug from origin"

sha="$(git rev-parse HEAD)"
status_state="$(gh api "repos/${repo_slug}/commits/${sha}/status" --jq '.state')"
[[ "${status_state}" = "success" ]] || fail "HEAD commit checks must be green (state: ${status_state})"

main_section="$(
  awk '
    /^## main$/ { in_main = 1; next }
    /^## / && in_main { exit }
    in_main { print }
  ' CHANGELOG.md
)"

[[ -n "${main_section}" ]] || fail "missing or empty ## main section in CHANGELOG.md"

echo "${main_section}" | grep -q '\- \[x\]' || fail "CHANGELOG.md ## main section must contain at least one completed item (- [x])"
if echo "${main_section}" | grep -q '\- \[ \]'; then
  fail "CHANGELOG.md ## main section still contains open checklist items (- [ ])"
fi

echo "release-ready: ok"
