#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

echo "ACCPTST:STDIO_REPLACE_DATETIMES"

bash "${__root}/main.sh" -f /tmp/x -h
