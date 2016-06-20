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
# More info:
#
#  - https://github.com/kvz/bash3boilerplate
#  - http://kvz.io/blog/2013/02/26/introducing-bash3boilerplate/
#
# Version: 2.0.0
#
# Authors:
#
#  - Kevin van Zonneveld (http://kvz.io)
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
# Copyright (c) 2013 Kevin van Zonneveld and [contributors](https://github.com/kvz/bash3boilerplate#authors)
# Licensed under [MIT](https://raw.githubusercontent.com/kvz/bash3boilerplate/master/LICENSE)
# You are not obligated to bundle the LICENSE file with your b3bp projects as long
# as you leave these references intact.

function ini_val() {
  local file="${1:-}"
  local sectionkey="${2:-}"
  local val="${3:-}"
  local delim=" = "
  local section=""
  local key=""

  # Split on . for section. However, section is optional
  read section key <<<$(IFS="."; echo ${sectionkey})
  if [ -z "${key}" ]; then
    key="${section}"
    section=""
  fi

  local current=$(awk -F "${delim}" "/^${key}${delim}/ {for (i=2; i<NF; i++) printf \$i \" \"; print \$NF}" "${file}")
  if [ -z "${val}" ]; then
    # get a value
    echo "${current}"
  else
    # set a value
    if [ -z "${current}" ]; then
      # doesn't exist yet, add

      if [ -z "${section}" ]; then
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

if [ "${BASH_SOURCE[0]}" != ${0} ]; then
  export -f ini_val
else
  ini_val "${@}"
  exit ${?}
fi
