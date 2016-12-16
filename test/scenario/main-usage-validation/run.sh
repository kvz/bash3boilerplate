#!/usr/bin/env bash
# shellcheck source=main.sh

set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

read -r -d '' __usage <<-'EOF' || true # exits non-zero when EOF encountered
  -0 --zero        Do nothing.
  -1 --one         Do one thing. Required.
                   More description.
  -2 --two         Do two things.
                   More. Required. Description.
  -3 --three [arg] Do three things.
                   Required.
  -4 --four  {arg} Do four things.
  -5 --five  {arg} Do five things. Required. Maybe.
  -6 --six   [arg] Do six things. Not Required.
                   Required, it is not.
  -7 --seven [arg] Required. Or bust.
  -8 --eight [arg] Do eight things.
                   More.Required.Description.
  -a         [arg] Do A.   Required.
                   Default="do-a"
  -b         {arg} Do B.Default="do-b"
  -c         [arg] Required.   Default="do-c"
  -d         {arg} Default="do-d"
EOF

export __usage
export NO_COLOR="true"

echo "ACCPTST:STDIO_REPLACE_DATETIMES"

echo "# complain about -3"
(source "${__root}/main.sh") || true

echo "# complain about -4"
(source "${__root}/main.sh" -3 arg3) || true

echo "# complain about -5"
(source "${__root}/main.sh" -3 arg3 -4 arg4) || true

echo "# complain about -8 (because -7 syntax is not supported)"
(source "${__root}/main.sh" -3 arg3 -4 arg4 -5 arg5) || true

echo "# complain about -d (because -d syntax is not supported)"
(source "${__root}/main.sh" -3 arg3 -4 arg4 -5 arg5 -8 arg8) || true

echo "# complain about nothing"
(
  source "${__root}/main.sh" -3 arg3 -4 arg4 -5 arg5 -8 arg8 -d argd
  for argument in ${!arg_*}; do info "${argument}: ${!argument}"; done
)
