#!/usr/bin/env bash
# BASH3 Boilerplate: megamount
#
# This file:
#
#  - Takes a URL (smb, nfs, afs) and tries to mount it at a given target directory
#  - Forcefully unmounts any active mount at the target directory first
#  - Displays the mount's contents for verification
#
# Depends on:
#
#  - ./parse_url.sh
#
# Usage as a function:
#
#  source megamount.sh
#  megamount smb://janedoe:abc123@192.168.0.1/documents /mnt/documents
#
# Usage as a command:
#
#  megamount.sh smb://janedoe:abc123@192.168.0.1/documents /mnt/documents
#
# Based on a template by BASH3 Boilerplate v2.3.0
# http://bash3boilerplate.sh/#authors
#
# The MIT License (MIT)
# Copyright (c) 2013 Kevin van Zonneveld and contributors
# You are not obligated to bundle the LICENSE file with your b3bp projects as long
# as you leave these references intact in the header comments of your source files.

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=src/parse_url.sh
source "${__dir}/parse_url.sh"

function megamount () {
  local url="${1}"
  local target="${2}"

  local proto
  local user
  local pass
  local host
  local port
  local path

  proto=$(parse_url "${url}" "proto")
  user=$(parse_url "${url}" "user")
  pass=$(parse_url "${url}" "pass")
  host=$(parse_url "${url}" "host")
  port=$(parse_url "${url}" "port")
  path=$(parse_url "${url}" "path")

  (umount -lf "${target}" || umount -f "${target}") > /dev/null 2>&1 || true
  mkdir -p "${target}"
  if [[ "${proto}" = "smb://" ]]; then
    mount -t cifs --verbose -o "username=${user},password=${pass},hard" "//${host}/${path}" "${target}"
  elif [[ "${proto}" = "afp://" ]]; then
    # start syslog-ng
    # afpfsd || echo "Unable to run afpfsd. Does /dev/log exist?" && exit 1
    mount_afp "${url}" "${target}"
  elif [[ "${proto}" = "nfs://" ]]; then
    mount -t nfs --verbose -o "vers=3,nolock,soft,intr,rsize=32768,wsize=32768" "${host}:/${path}" "${target}"
  else
    echo "ERR: Unknown protocol: '${proto}'"
    exit 1
  fi

  # chmod 777 "${target}"
  ls -al "${target}/"
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  export -f megamount
else
  megamount "${@}"
  exit ${?}
fi
