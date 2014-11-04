#!/usr/bin/env bash
function ini_val() {
  local file="${1}"
  local sectionkey="${2}"
  local val="${3}"
  local delim=" = "
  local section=""
  local key=""

  # Split on . for section. However, section is optional
  read section key <<<$(IFS="."; echo ${sectionkey})
  if [ -z "${key}" ]; then
    key="${section}"
    section=""
  fi

  local current=$(awk -F"${delim}" "/^${key}${delim}/ {for (i=2; i<NF; i++) printf \$i \" \"; print \$NF}" "${file}")
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
        sed "/\[${section}\]/a ${key}${delim}${val}" -i "${file}"
      fi
    else
      # replace existing
      sed "/^${key}${delim}/s/${delim}.*/${delim}${val}/" -i "${file}"
    fi
  fi
}
