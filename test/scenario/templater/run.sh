#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

echo "--"
env TARGET_HOST="127.0.0.1" bash "${__root}/src/templater.sh" ./app.template.cfg ./app.cfg
cat app.cfg
rm -f app.cfg

echo "--"
export TARGET_HOST="127.0.0.1"

# shellcheck source=src/templater.sh
source "${__root}/src/templater.sh"

templater ./app.template.cfg ./app.cfg
cat app.cfg
rm -f app.cfg

echo "--"
env ALLOW_REMAINDERS="1" TARGET_HOST="127.0.0.1" bash "${__root}/src/templater.sh" ./break.template.cfg ./break.cfg
cat break.cfg
rm -f break.cfg

echo "--"
env TARGET_HOST="127.0.0.1" bash "${__root}/src/templater.sh" ./break.template.cfg ./break.cfg
cat break.cfg
rm -f break.cfg
