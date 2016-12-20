#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

bash "${__root}/src/parse_url.sh" 'http://johndoe:abc123@example.com:8080/index.html' pass
bash "${__root}/src/parse_url.sh" 'http://johndoe:abc123@example.com:8080/index.html'

# shellcheck source=src/parse_url.sh
source "${__root}/src/parse_url.sh"

parse_url 'http://johndoe:abc123@example.com:8080/index.html' pass
parse_url 'http://johndoe:abc123@example.com:8080/index.html'
