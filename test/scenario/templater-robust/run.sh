#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

__template_tmp="$(mktemp "${TMPDIR:-/tmp}/templater-robust-template.XXXXXX")"
__output_tmp="$(mktemp "${TMPDIR:-/tmp}/templater-robust-output.XXXXXX")"
__error_tmp="$(mktemp "${TMPDIR:-/tmp}/templater-robust-error.XXXXXX")"

function cleanup_before_exit () {
  rm -f "${__template_tmp:?}" "${__output_tmp:?}" "${__error_tmp:?}"
}
trap cleanup_before_exit EXIT

cat > "${__template_tmp}" <<-'EOF'
line1=${VALUE_ONE}
line2=${VALUE_TWO}
line3=${UNSET_VALUE}
EOF

echo "# command-mode-special-values"
env ALLOW_REMAINDERS=1 VALUE_ONE='a&b/c#d' VALUE_TWO='value with spaces' \
  bash "${__root}/src/templater.sh" "${__template_tmp}" "${__output_tmp}"
cat "${__output_tmp}"

echo "# source-mode-special-values"
# shellcheck source=src/templater.sh
source "${__root}/src/templater.sh"
VALUE_ONE='x-y-z' VALUE_TWO='another value' ALLOW_REMAINDERS=1 templater "${__template_tmp}" "${__output_tmp}"
cat "${__output_tmp}"

echo "# command-mode-missing-template"
set +o errexit
bash "${__root}/src/templater.sh" ./does-not-exist.template "${__output_tmp}" > "${__error_tmp}" 2>&1
__rc=$?
set -o errexit
echo "exit: ${__rc}"
cat "${__error_tmp}"
