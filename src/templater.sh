#!/usr/bin/env bash
# Copyright (c) 2014, Transloadit Ltd.
#
# This file
#  - takes a source (template) & destination (config) filepath argument
#  - and then replaces placeholders with variables found in the environment
#
# Authors:
#  - Kevin van Zonneveld <kevin@transloadit.com>

set -o pipefail
set -o errexit
# set -o xtrace
# set -o nounset

sed=""
[ -n "$(which sed)" ]  && sed="$(which sed)"
[ -n "$(which gsed)" ] && sed="$(which gsed)"

templateSrc="${1}"
templateDst="${2}"

if [ ! -f "${templateSrc}" ]; then
  echo "ERROR: Template source '${templateSrc}' needs to exist"
  exit 1
fi
if [ ! -n "${templateDst}" ]; then
  echo "ERROR: Template destination '${templateDst}' needs to exist"
  exit 1
fi

cp -f "${templateSrc}" "${templateDst}"
for var in $(env |awk -F= '{print $1}' |egrep '^[A-Z0-9_]+$'); do
  ${sed} "s#\${${var}}#${!var}#g" -i "${templateDst}"
done

# cat "${templateDst}"

if grep '${' ${templateDst}; then
   echo "ERROR: Unable to replace the above template vars"
   exit 1
fi
