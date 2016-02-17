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

__sysTmpDir="${TMPDIR:-/tmp}"
__sysTmpDir="${__sysTmpDir%/}" # <-- remove trailing slash on macosx

# Currently I only know how to test a failing condition here since
# it's too invasive to create actual mounts to play with on a system

bash "${__root}/src/megamount.sh" 'foobarfs://janedoe:abc123@192.168.0.1/documents' "${__sysTmpDir}/mnt/documents" || true

source ${__root}/src/megamount.sh
megamount 'foobarfs://janedoe:abc123@192.168.0.1/documents' "${__sysTmpDir}/mnt/documents"
