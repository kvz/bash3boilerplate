#!/usr/bin/env bash
# Exit on error. Append ||true if you expect an error.
# `set` is safer than relying on a shebang like `#!/bin/bash -e` because that is neutralized
# when someone runs your script as `bash yourscript.sh`
set -o errexit
set -o nounset

# Bash will remember & return the highest exitcode in a chain of pipes.
# This way you can catch the error in case mysqldump fails in `mysqldump |gzip`
set -o pipefail
# set -o xtrace

# Environment variables and their defaults
LOG_LEVEL="${LOG_LEVEL:-6}" # 7 = debug -> 0 = emergency
NO_COLOR="${NO_COLOR:-}"    # true = disable color. otherwise autodetected
