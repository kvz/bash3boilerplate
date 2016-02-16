#!/usr/bin/env bash
# set -o pipefail
# set -o errexit
set -o nounset
# set -o xtrace

# Set magic variables for current FILE & DIR
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname $(dirname $(dirname "${__dir}")))" && pwd)"

echo "B3BP:STDIO_REPLACE_DATETIMES"

(env LOG_LEVEL=6 bash "${__root}/main.sh" --file /tmp/x;
env LOG_LEVEL=6 bash "${__root}/main.sh" --file=/tmp/x;
env LOG_LEVEL=6 bash "${__root}/main.sh" -f /tmp/x) 2>&1 |grep arg_f
