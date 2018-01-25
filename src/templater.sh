#!/usr/bin/env bash
# BASH3 Boilerplate: templater
#
# This file:
#
#  - takes a source (template) & destination (config) filepath argument
#  - then replaces placeholders with variables found in the environment
#
# Usage as a function:
#
#  source templater.sh
#  export NAME=kevin
#  templater input.cfg output.cfg
#
# Usage as a command:
#
#  ALLOW_REMAINDERS=1 templater.sh input.cfg output.cfg
#
# Based on a template by BASH3 Boilerplate v2.3.0
# http://bash3boilerplate.sh/#authors
#
# The MIT License (MIT)
# Copyright (c) 2013 Kevin van Zonneveld and contributors
# You are not obligated to bundle the LICENSE file with your b3bp projects as long
# as you leave these references intact in the header comments of your source files.

function templater() {
  ALLOW_REMAINDERS="${ALLOW_REMAINDERS:-0}"

  templateSrc="${1:-}"
  templateDst="${2:-}"

  if [[ ! -f "${templateSrc}" ]]; then
    echo "ERROR: Template source '${templateSrc}' needs to exist"
    exit 1
  fi
  if [[ ! "${templateDst}" ]]; then
    echo "ERROR: Template destination '${templateDst}' needs to be specified"
    exit 1
  fi

  if [[ "$(command -v perl)" ]]; then
    perl -p -e 's/\$\{(\w+)\}/(exists $ENV{$1} ? $ENV{$1} : "\${$1}")/eg' < "${templateSrc}" > "${templateDst}"
  else
    cp -f "${templateSrc}" "${templateDst}"

    for var in $(env |awk -F= '{print $1}' |grep -E '^(_[A-Z0-9_]+|[A-Z0-9][A-Z0-9_]*)$'); do
      sed -i.bak -e "s#\${${var}}#${!var//#/\\#/}#g" "${templateDst}"
      # this .bak dance is done for BSD/GNU portability: http://stackoverflow.com/a/22084103/151666
      rm -f "${templateDst}.bak"
    done
  fi

  # cat "${templateDst}"

  # shellcheck disable=SC2016
  if grep '${' "${templateDst}" && [[ "${ALLOW_REMAINDERS}" = "0" ]]; then
    echo "ERROR: Unable to replace the above template vars"
    exit 1
  fi
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  export -f templater
else
  templater "${@}"
  exit ${?}
fi
