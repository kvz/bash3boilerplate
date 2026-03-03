#!/usr/bin/env bash
set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "${__dir}")" && pwd)"

B3BP_BASH3_IMAGE="${B3BP_BASH3_IMAGE:-bash:3.2.57}"

docker run --rm \
  --volume "${__root}:/workspace" \
  --workdir /workspace \
  --env NO_COLOR=true \
  "${B3BP_BASH3_IMAGE}" \
  sh -lc '
    set -o errexit
    set -o nounset
    set -o pipefail

    apk add --no-cache coreutils diffutils nodejs perl >/dev/null
    bash --version | head -n 1
    test/acceptance.sh
  '
