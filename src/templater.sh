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
# Based on a template by BASH3 Boilerplate v2.7.2
# https://bash3boilerplate.sh/#authors
#
# The MIT License (MIT)
# Copyright (c) 2013 Kevin van Zonneveld and contributors
# You are not obligated to bundle the LICENSE file with your b3bp projects as long
# as you leave these references intact in the header comments of your source files.

function templater() (
  set -o errexit
  set -o errtrace
  set -o nounset
  set -o pipefail

  local ALLOW_REMAINDERS="${ALLOW_REMAINDERS:-0}"
  local templateSrc="${1:-}"
  local templateDst="${2:-}"
  local var=""

  if [[ ! -f "${templateSrc}" ]]; then
    echo "ERROR: Template source '${templateSrc}' needs to exist" 1>&2
    exit 1
  fi
  if [[ ! "${templateDst}" ]]; then
    echo "ERROR: Template destination '${templateDst}' needs to be specified" 1>&2
    exit 1
  fi

  if [[ "$(command -v perl)" ]]; then
    perl -p -e 's/\$\{(\w+)\}/(exists $ENV{$1} ? $ENV{$1} : "\${$1}")/eg' <"${templateSrc}" >"${templateDst}"
  else
    cp -f "${templateSrc}" "${templateDst}"

    for var in $(env | awk -F= '{print $1}' | grep -E '^(_[A-Z0-9_]+|[A-Z0-9][A-Z0-9_]*)$'); do
      sed -i.bak -e "s#\${${var}}#${!var//#/\\#/}#g" "${templateDst}"
      # this .bak dance is done for BSD/GNU portability: https://stackoverflow.com/a/22084103/151666
      rm -f "${templateDst}.bak"
    done
  fi

  # cat "${templateDst}"

  # shellcheck disable=SC2016
  if grep '${' "${templateDst}" && [[ "${ALLOW_REMAINDERS}" = "0" ]]; then
    echo "ERROR: Unable to replace the above template vars"
    exit 1
  fi
)

if [[ "${BASH_SOURCE[0]:-}" != "${0}" ]]; then
  export -f templater
else
  templater "$@"
  exit
fi
