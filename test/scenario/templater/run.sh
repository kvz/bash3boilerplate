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

echo "--"
env TARGET_HOST="127.0.0.1" bash "${__root}/src/templater.sh" ./app.template.cfg ./app.cfg
cat app.cfg
rm -f app.cfg

echo "--"
export TARGET_HOST="127.0.0.1"
source ${__root}/src/templater.sh
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
