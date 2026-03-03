#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

# shellcheck source=src/parse_url.sh
source "${__root}/src/parse_url.sh"

echo "# no-proto-with-path"
echo "host=$(parse_url 'example.com/path/to/resource' host)"
echo "path=$(parse_url 'example.com/path/to/resource' path)"

echo "# https-default-port"
echo "port=$(parse_url 'https://example.com' port)"

echo "# redis-default-port"
echo "port=$(parse_url 'redis://cache.internal' port)"

echo "# user-without-pass"
echo "user=$(parse_url 'ssh://jane@example.org' user)"
echo "pass=$(parse_url 'ssh://jane@example.org' pass)"

echo "# explicit-port-no-path"
echo "host=$(parse_url 'http://api.example.org:9000' host)"
echo "port=$(parse_url 'http://api.example.org:9000' port)"
echo "path=$(parse_url 'http://api.example.org:9000' path)"
