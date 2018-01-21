#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

read -r -d '' __usage <<-'EOF' || true # exits non-zero when EOF encountered
  -1 --one         Do one thing. Default="ONE"
                   More description.
  -2 --two         Do two things.
                   More description. Default="TWO"
  -3 --three [arg] Do three things. Default="'THREE'"
                   More description.
  -4 --four  [arg] Do four things.
                   More description. Default='"FOUR"'
  -5 --five  [arg] Do five things. Default="FIVE"
                   More description. Default='OOOPS'
  -6 --six   [arg] Do six things.
                   More description.
EOF

export __usage

echo "ACCPTST:STDIO_REPLACE_DATETIMES"

# shellcheck source=main.sh
source "${__root}/main.sh"

for argument in ${!arg_*}; do info "${argument}: ${!argument}"; done
