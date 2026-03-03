#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

__ini_tmp="$(mktemp "${TMPDIR:-/tmp}/ini-val-robust.XXXXXX")"
function cleanup_before_exit() { rm -f "${__ini_tmp:?}"; }
trap cleanup_before_exit EXIT

echo "# command-mode-default-section"
bash "${__root}/src/ini_val.sh" "${__ini_tmp}" orphan "value-with-hyphen"
bash "${__root}/src/ini_val.sh" "${__ini_tmp}" orphan

echo "# command-mode-comment-roundtrip"
bash "${__root}/src/ini_val.sh" "${__ini_tmp}" section.key "value-one" "section key comment"
bash "${__root}/src/ini_val.sh" "${__ini_tmp}" section.key "value-two"
bash "${__root}/src/ini_val.sh" "${__ini_tmp}" section.key

echo "# source-mode-default-section"
# shellcheck source=src/ini_val.sh
source "${__root}/src/ini_val.sh"
ini_val "${__ini_tmp}" source_only "from-source"
ini_val "${__ini_tmp}" source_only

echo "# final-ini"
cat "${__ini_tmp}"
