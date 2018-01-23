#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename "${__file}" .sh)"

__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

__templaterTmpFile=$(mktemp "${TMPDIR:-/tmp}/${__base}.XXXXXX")
function cleanup_before_exit () { rm "${__templaterTmpFile:?}"; }
trap cleanup_before_exit EXIT

echo "--"
env TARGET_HOST="127.0.0.1" bash "${__root}/src/templater.sh" ./app.template.cfg "${__templaterTmpFile}"
cat "${__templaterTmpFile}"

echo "--"
export TARGET_HOST="127.0.0.1"

# shellcheck source=src/templater.sh
source "${__root}/src/templater.sh"

templater ./app.template.cfg "${__templaterTmpFile}"
cat "${__templaterTmpFile}"

echo "--"
env ALLOW_REMAINDERS="1" TARGET_HOST="127.0.0.1" bash "${__root}/src/templater.sh" ./break.template.cfg "${__templaterTmpFile}"
cat "${__templaterTmpFile}"

echo "--"
env TARGET_HOST="127.0.0.1" bash "${__root}/src/templater.sh" ./break.template.cfg "${__templaterTmpFile}"
cat "${__templaterTmpFile}"
