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

command -v gh >/dev/null || fail "GitHub CLI (gh) is required"
gh auth status >/dev/null 2>&1 || fail "gh is not authenticated"

repo_slug="$(gh repo view --json nameWithOwner --jq '.nameWithOwner' 2>/dev/null || true)"
[[ -n "${repo_slug}" ]] || fail "unable to resolve repository slug via gh repo view"

sha="$(git rev-parse HEAD)"
check_runs_total="$(
  gh api "repos/${repo_slug}/commits/${sha}/check-runs" --jq '.total_count' 2>/dev/null || true
)"
[[ -n "${check_runs_total}" ]] || fail "unable to read check-runs for HEAD commit"
[[ "${check_runs_total}" != "0" ]] || fail "HEAD commit has no check-runs"

check_runs_pending="$(
  gh api "repos/${repo_slug}/commits/${sha}/check-runs" --jq '[.check_runs[] | select(.status != "completed")] | length'
)"
[[ "${check_runs_pending}" = "0" ]] || fail "HEAD commit has pending check-runs (${check_runs_pending})"

check_runs_failing="$(
  gh api "repos/${repo_slug}/commits/${sha}/check-runs" --jq '[.check_runs[] | select(.status == "completed" and (.conclusion != "success" and .conclusion != "neutral" and .conclusion != "skipped"))] | length'
)"
[[ "${check_runs_failing}" = "0" ]] || fail "HEAD commit has failing check-runs (${check_runs_failing})"

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
