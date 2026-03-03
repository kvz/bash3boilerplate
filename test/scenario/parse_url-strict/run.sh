#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

# shellcheck source=src/parse_url.sh
source "${__root}/src/parse_url.sh"

echo "# strict-http-host"
parse_url 'http://example.com/index.html' host

echo "# strict-https-port"
parse_url 'https://example.com' port

echo "# strict-mysql-default-port"
parse_url 'mysql://db.internal' port

echo "# strict-no-proto-host"
parse_url 'example.com/path' host
