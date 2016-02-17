#!/usr/bin/env bash
# BASH3 Boilerplate: templater
#
# This file:
#  - takes a source (template) & destination (config) filepath argument
#  - then replaces placeholders with variables found in the environment
#
# More info:
#  - https://github.com/kvz/bash3boilerplate
#  - http://kvz.io/blog/2013/02/26/introducing-bash3boilerplate/
#
# Version: 1.2.1
#
# Authors:
#  - Kevin van Zonneveld (http://kvz.io)
#
# Usage as a function:
#
#  source templater.sh
#  NAME=kevin templater input.cfg output.cfg
#
# Usage as a command:
#
#  ALLOW_REMAINDERS=1 templater.sh input.cfg output.cfg
#
# Licensed under MIT
# Copyright (c) 2016 Kevin van Zonneveld (http://kvz.io)

function templater() {
  sed=""
  [ -n "$(which sed)" ]  && sed="$(which sed)"
  [ -n "$(which gsed)" ] && sed="$(which gsed)"

  ALLOW_REMAINDERS="${ALLOW_REMAINDERS:-0}"

  templateSrc="${1:-}"
  templateDst="${2:-}"

  if [ ! -f "${templateSrc}" ]; then
    echo "ERROR: Template source '${templateSrc}' needs to exist"
    exit 1
  fi
  if [ ! -n "${templateDst}" ]; then
    echo "ERROR: Template destination '${templateDst}' needs to be specified"
    exit 1
  fi

  cp -f "${templateSrc}" "${templateDst}"
  for var in $(env |awk -F= '{print $1}' |egrep '^[A-Z0-9_]+$'); do
    ${sed} -i.bak -e "s#\${${var}}#${!var}#g" "${templateDst}"
    # this .bak dance is done for BSD/GNU portability: http://stackoverflow.com/a/22084103/151666
    rm -f "${templateDst}.bak"
  done

  # cat "${templateDst}"

  if grep '${' ${templateDst} && [ "${ALLOW_REMAINDERS}" = "0" ]; then
    echo "ERROR: Unable to replace the above template vars"
    exit 1
  fi
}

if [ "${BASH_SOURCE[0]}" != ${0} ]; then
  export -f templater
else
  templater "${@}"
  exit ${?}
fi
