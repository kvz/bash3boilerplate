#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

# Set magic variables for current FILE & DIR
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname $(dirname $(dirname "${__dir}")))" && pwd)"

# Set __usage and source main.sh
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

echo "ACCPTST:STDIO_REPLACE_DATETIMES"

source "${__root}/main.sh"

for argument in ${!arg_*}; do info "${argument}: ${!argument}"; done
