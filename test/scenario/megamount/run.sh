#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

__sysTmpDir="${TMPDIR:-/tmp}"
__sysTmpDir="${__sysTmpDir%/}" # <-- remove trailing slash on macosx

# Currently I only know how to test a failing condition here since
# it's too invasive to create actual mounts to play with on a system

bash "${__root}/src/megamount.sh" 'foobarfs://janedoe:abc123@192.168.0.1/documents' "${__sysTmpDir}/mnt/documents" || true

# shellcheck source=src/megamount.sh
source "${__root}/src/megamount.sh"

megamount 'foobarfs://janedoe:abc123@192.168.0.1/documents' "${__sysTmpDir}/mnt/documents"
