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

bash "${__root}/src/parse_url.sh" 'http://johndoe:abc123@example.com:8080/index.html' pass
bash "${__root}/src/parse_url.sh" 'http://johndoe:abc123@example.com:8080/index.html'

source ${__root}/src/parse_url.sh
parse_url 'http://johndoe:abc123@example.com:8080/index.html' pass
parse_url 'http://johndoe:abc123@example.com:8080/index.html'
