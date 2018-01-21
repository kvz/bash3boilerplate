#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

# Set magic variables for current FILE & DIR
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "$(dirname "$(dirname "${__dir}")")")" && pwd)"

# echo "ACCPTST:STDIO_REPLACE_DATETIMES"


# Use as standalone:
cp -f data.ini dummy.ini
echo "--> command: Read 3 values"
bash "${__root}/src/ini_val.sh" ./dummy.ini orphan
bash "${__root}/src/ini_val.sh" ./dummy.ini connection.host
bash "${__root}/src/ini_val.sh" ./dummy.ini software.packages

echo "--> command: Replace three values in-place and show result"
bash "${__root}/src/ini_val.sh" ./dummy.ini orphan "no more"
bash "${__root}/src/ini_val.sh" ./dummy.ini connection.host "192.168.0.1"
bash "${__root}/src/ini_val.sh" ./dummy.ini software.packages "vim"
cat dummy.ini
rm -f dummy.ini

# Use as include:
cp -f data.ini dummy.ini

# shellcheck source=main.sh
source "${__root}/src/ini_val.sh"

echo "--> function: Read 3 values"
ini_val ./dummy.ini orphan
ini_val ./dummy.ini connection.host
ini_val ./dummy.ini software.packages

echo "--> function: Replace three values in-place and show result"
ini_val ./dummy.ini orphan "no more"
ini_val ./dummy.ini connection.host "192.168.0.1"
ini_val ./dummy.ini software.packages "vim"
cat dummy.ini
rm -f dummy.ini
