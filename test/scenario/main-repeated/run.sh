#!/usr/bin/env bash
# set -o pipefail
# set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

echo "ACCPTST:STDIO_REPLACE_DATETIMES"

(
  env LOG_LEVEL=6 bash "${__root}/main.sh" -f dummy -i simple_input -i "input_in_quotes" -i "input with spaces" -i "input with \"quotes\"" -i last_input
) 2>&1 |grep arg_i -A 5

(
  env LOG_LEVEL=6 bash "${__root}/main.sh" -x -f dummy -x -x
  env LOG_LEVEL=6 bash "${__root}/main.sh" -f dummy -xxxx
) 2>&1 |grep arg_x
