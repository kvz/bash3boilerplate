#!/usr/bin/env bash
# Copyright (c) 2014, Transloadit Ltd.
#
# This file:
#
#  - Bumps a semantic version as specified in first argument
#  - Or: Bumps a semantic version in a file as specified in first argument
#  - Returns the version if no levelName is provided in second argument
#  - Only supports Go files ending in 'var Version = ...'
#
# Run as:
#
#  ./bump.sh 0.0.1 patch
#  ./bump.sh ./VERSION patch
#  ./bump.sh ./VERSION patch
#  ./bump.sh ./VERSION major 1
#  ./bump.sh ./version.go patch 2
#
# Returns:
#
# v0.0.1
#
# Requires:
#
#  - gsed on OSX (brew install gnu-sed)
#
# Authors:
#
#  - Kevin van Zonneveld <kevin@transloadit.com>

set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

# Set magic variables for current FILE & DIR
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "${__dir}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"

gsed=""
[ -n "$(which sed)" ]  && gsed="$(which sed)"
[ -n "$(which gsed)" ] && gsed="$(which gsed)"


. ${__dir}/semver.sh

function readFromFile() {
  local filepath="${1}"
  local extension="${filepath##*.}"

  if [ "${extension}" = "go" ]; then
    curVersion="$(awk -F'"' '/^var Version = / {print $2}' "${filepath}" | tail -n1)" || true
  else
    curVersion="$(echo $(cat "${filepath}"))" || true
  fi

  if [ -z "${curVersion}" ]; then
    curVersion="v0.0.0"
  fi

  echo "${curVersion}"
}

function writeToFile() {
  local filepath="${1}"
  local newVersion="${2}"
  local extension="${filepath##*.}"

  if [ "${extension}" = "go" ]; then
    buf="$(cat "${filepath}" |egrep -v '^var Version = ')" || true
    echo -e "${buf}\nvar Version = \"${newVersion}\"" > "${filepath}"
  else
    echo "${newVersion}" > "${filepath}"
  fi
}

function bump() {
  local version="${1}"
  local levelName="${2}"
  local bump="${3}"

  local major=0
  local minor=0
  local patch=0
  local special=""

  local newVersion=""

  semverParseInto "${version}" major minor patch special

  if [ "${levelName}" = "major" ]; then
    let "major = major + ${bump}"
    minor=0
    patch=0
    special=""
  fi
  if [ "${levelName}" = "minor" ]; then
    let "minor = minor + ${bump}"
    patch=0
    special=""
  fi
  if [ "${levelName}" = "patch" ]; then
    let "patch = patch + ${bump}"
    special=""
  fi
  if [ "${levelName}" = "special" ]; then
    special="${bump}"
  fi

  newVersion="v${major}.${minor}.${patch}"
  if [ -n "${special}" ]; then
    newVersion=".${newVersion}"
  fi
  echo "${newVersion}"
}

if [ -f "${1}" ]; then
  filepath="${1}"
  curVersion="$(readFromFile "${filepath}")"
else
  curVersion="${1}"
fi

newVersion=$(bump "${curVersion}" "${2:-}" "${3:-1}")
echo "${newVersion}"

if [ -n "${filepath:-}" ]; then
  writeToFile "${filepath}" "${newVersion}"
fi
