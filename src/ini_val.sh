#!/usr/bin/env bash
# BASH3 Boilerplate: ini_val
#
# This file:
#
#  - Can read and write .ini files using pure bash
#
# Limitations:
#
#  - All keys inside the .ini file must be unique, regardless of the use of sections
#
# Usage as a function:
#
#  source ini_val.sh
#  ini_val data.ini connection.host 127.0.0.1
#
# Usage as a command:
#
#  ini_val.sh data.ini connection.host 127.0.0.1
#
# Based on a template by BASH3 Boilerplate v2.3.0
# http://bash3boilerplate.sh/#authors
#
# The MIT License (MIT)
# Copyright (c) 2013 Kevin van Zonneveld and contributors
# You are not obligated to bundle the LICENSE file with your b3bp projects as long
# as you leave these references intact in the header comments of your source files.

function ini_val() {
  local file="${1:-}"
  local sectionkey="${2:-}"
  local val="${3:-}"
  local delim=" = "
  local section=""
  local key=""

  # Split on . for section. However, section is optional
  IFS='.' read -r section key <<< "${sectionkey}"
  if [[ ! "${key}" ]]; then
    key="${section}"
    section=""
  fi

  local current
  current=$(awk -F "${delim}" "/^${key}${delim}/ {for (i=2; i<NF; i++) printf \$i \" \"; print \$NF}" "${file}")

  if [[ ! "${val}" ]]; then
    # get a value
    echo "${current}"
  else
    # set a value
    if [[ ! "${current}" ]]; then
      # doesn't exist yet, add

      if [[ ! "${section}" ]]; then
        # no section was given, add to bottom of file
        echo "${key}${delim}${val}" >> "${file}"
      else
        # add to section
        sed -i.bak -e "/\[${section}\]/a ${key}${delim}${val}" "${file}"
        # this .bak dance is done for BSD/GNU portability: http://stackoverflow.com/a/22084103/151666
        rm -f "${file}.bak"
      fi
    else
      # replace existing
      sed -i.bak -e "/^${key}${delim}/s/${delim}.*/${delim}${val}/" "${file}"
      # this .bak dance is done for BSD/GNU portability: http://stackoverflow.com/a/22084103/151666
      rm -f "${file}.bak"
    fi
  fi
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  export -f ini_val
else
  ini_val "${@}"
  exit ${?}
fi
