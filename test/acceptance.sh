#!/usr/bin/env bash
# This file:
#
#  - Executes one (or all) test scenarios
#  - Replaces dynamic things like hostnames, IPs, dates, etc
#  - Optionally saves the results as fixtures, that later runs will be compared against
#
# Usage:
#
#  ./deploy.sh
#
# Based on a template by BASH3 Boilerplate v2.0.0
# http://bash3boilerplate.sh/#authors
#
# The MIT License (MIT)
# Copyright (c) 2013 Kevin van Zonneveld and contributors
# You are not obligated to bundle the LICENSE file with your b3bp projects as long
# as you leave these references intact in the header comments of your source files.

# Exit on error. Append || true if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace

# Set magic variables for current file, directory, os, etc.
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename "${__file}" .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)"

__sysTmpDir="${TMPDIR:-/tmp}"
__sysTmpDir="${__sysTmpDir%/}" # <-- remove trailing slash on macosx
__accptstTmpDir=$(mktemp -d "${__sysTmpDir}/${__base}.XXXXXX")

function cleanup_before_exit () { rm -r "${__accptstTmpDir:?}"; }
trap cleanup_before_exit EXIT

cmdSed="sed"
cmdTimeout="timeout"

if [[ "${OSTYPE}" = "darwin"* ]]; then
  cmdSed="gsed"
  cmdTimeout="gtimeout"
fi

if [[ ! "$(command -v ${cmdSed})" ]]; then
  echo "Please install ${cmdSed}"
  exit 1
fi

if [[ ! "$(command -v ${cmdTimeout})" ]]; then
  echo "Please install ${cmdTimeout}"
  exit 1
fi

__node="$(which node)"
__arch="amd64"

# explicitly setting NO_COLOR to false will make b3bp ignore TERM
# not being "xterm*" or "screen*" and STDERR not being connected to a terminal
# it's the opposite of NO_COLOR="true" - it forces color, no matter what
export NO_COLOR="false"

# Running prepare before other scenarios is important on Travis,
# so that stdio can diverge - and we can enforce stricter
# stdio comparison on all other tests.
while IFS=$'\n' read -r scenario; do
  scenario="$(dirname "${scenario}")"
  scenario="${scenario##${__dir}/scenario/}"

  [[ "${scenario}" = "prepare" ]] && continue
  [[ "${1:-}" ]] && [[ "${scenario}" != "${1}" ]] && continue

  echo "==> Scenario: ${scenario}"
  pushd "${__dir}/scenario/${scenario}" > /dev/null

    # Run scenario
    (${cmdTimeout} --kill-after=6m 5m bash ./run.sh \
      > "${__accptstTmpDir}/${scenario}.stdio" 2>&1; \
      echo "${?}" > "${__accptstTmpDir}/${scenario}.exitcode" \
    ) || true

    # Clear out environmental specifics
    for typ in stdio exitcode; do
      curFile="${__accptstTmpDir}/${scenario}.${typ}"
      "${cmdSed}" -i \
        -e "s@${__node}@{node}@g" "${curFile}" \
        -e "s@${__root}@{root}@g" "${curFile}" \
        -e "s@${__sysTmpDir}@{tmpdir}@g" "${curFile}" \
        -e "s@/tmp@{tmpdir}@g" "${curFile}" \
        -e "s@${HOME:-/home/travis}@{home}@g" "${curFile}" \
        -e "s@${USER:-travis}@{user}@g" "${curFile}" \
        -e "s@travis@{user}@g" "${curFile}" \
        -e "s@kvz@{user}@g" "${curFile}" \
        -e "s@{root}/node_modules/\.bin/node@{node}@g" "${curFile}" \
        -e "s@{home}/build/{user}/fre{node}@{node}@g" "${curFile}" \
        -e "s@${HOSTNAME}@{hostname}@g" "${curFile}" \
        -e "s@${__arch}@{arch}@g" "${curFile}" \
        -e "s@${OSTYPE}@{OSTYPE}@g" "${curFile}" \
        -e "s@OSX@{os}@g" "${curFile}" \
        -e "s@Linux@{os}@g" "${curFile}" \
      || false

      if grep -q 'ACCPTST:STDIO_REPLACE_IPS' "${curFile}"; then
        "${cmdSed}" -i \
          -r 's@[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}@{ip}@g' \
        "${curFile}"

        # IPs vary in length. Ansible uses padding. {ip} does not vary in length
        # so kill the padding after it for consistent output
        "${cmdSed}" -i \
          -r 's@\{ip\}\s+@{ip} @g' \
        "${curFile}"
      fi
      if grep -q 'ACCPTST:STDIO_REPLACE_UUIDS' "${curFile}"; then
        "${cmdSed}" -i \
          -r 's@[0-9a-f\-]{32,40}@{uuid}@g' \
        "${curFile}"
      fi
      if grep -q 'ACCPTST:STDIO_REPLACE_BIGINTS' "${curFile}"; then
        # Such as: 3811298194
        "${cmdSed}" -i \
          -r 's@[0-9]{7,64}@{bigint}@g' \
        "${curFile}"
      fi
      if grep -q 'ACCPTST:STDIO_REPLACE_DATETIMES' "${curFile}"; then
        # Such as: 2016-02-10 15:38:44.420094
        "${cmdSed}" -i \
          -r 's@[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}@{datetime}@g' \
        "${curFile}"
      fi
      if grep -q 'ACCPTST:STDIO_REPLACE_LONGTIMES' "${curFile}"; then
        # Such as: 2016-02-10 15:38:44.420094
        "${cmdSed}" -i \
          -r 's@[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{6}@{longtime}@g' \
        "${curFile}"
      fi
      if grep -q 'ACCPTST:STDIO_REPLACE_DURATIONS' "${curFile}"; then
        # Such as: 0:00:00.001991
        "${cmdSed}" -i \
          -r 's@[0-9]{1,2}:[0-9]{2}:[0-9]{2}.[0-9]{6}@{duration}@g' \
        "${curFile}"
      fi
      if grep -q 'ACCPTST:STDIO_REPLACE_REMOTE_EXEC' "${curFile}"; then
        grep -Ev 'remote-exec\): [ a-zA-Z]' "${curFile}" > "${__sysTmpDir}/accptst-filtered.txt"
        mv "${__sysTmpDir}/accptst-filtered.txt" "${curFile}"
      fi
    done

    # Save these as new fixtures?
    if [[ "${SAVE_FIXTURES:-}" = "true" ]]; then
      for typ in stdio exitcode; do
        curFile="${__accptstTmpDir}/${scenario}.${typ}"
        cp -f \
          "${curFile}" \
          "${__dir}/fixture/${scenario}.${typ}"
      done
    fi

    # Compare
    for typ in stdio exitcode; do
      curFile="${__accptstTmpDir}/${scenario}.${typ}"

      echo -n "    comparing ${typ}.. "

      if [[ "${typ}" = "stdio" ]]; then
        if grep -q 'ACCPTST:STDIO_SKIP_COMPARE' "${curFile}"; then
          echo "skip"
          continue
        fi
      fi

      if ! diff --strip-trailing-cr "${__dir}/fixture/${scenario}.${typ}" "${curFile}"; then
        echo -e "\\n\\n==> MISMATCH OF: ${scenario}.${typ} ---^"
        echo -e "\\n\\n==> EXPECTED STDIO: "
        cat "${__dir}/fixture/${scenario}.stdio" || true
        echo -e "\\n\\n==> ACTUAL STDIO: "
        cat "${__accptstTmpDir}/${scenario}.stdio" || true
        exit 1
      fi

      echo "✓"
    done

  popd > /dev/null
done <<< "$(find "${__dir}/scenario" -type f -iname 'run.sh')"

[[ "${1:-}" ]] && exit 0

# Ensure correct syntax with all available bashes

while IFS=$'\n' read -r bash; do
  # shellcheck disable=SC2016
  echo "==> ${bash} -n $(${bash} -c 'echo "(${BASH_VERSION})"')"
  pushd "${__root}" > /dev/null

  failed="false"

  while IFS=$'\n' read -r file; do
    [[ "${file}" =~ ^\./node_modules/ ]] && continue
    [[ "${file}" =~ ^\./website/\.lanyon/ ]] && continue

    echo -n "    ${file}.. "

    if ! "${bash}" -n "${file}" 2>> "${__accptstTmpDir}/${bash//\//.}.err"; then
      echo "✗"
      failed="true"
      continue
    fi

    echo "✓"
  done <<< "$(find . -type f -iname '*.sh')"

  popd > /dev/null

  if [[ "${failed}" = "true" ]]; then
    cat "${__accptstTmpDir}/${bash//\//.}.err"
    exit 1
  fi
done <<< "$(which -a bash 2>/dev/null)"

# do some shellcheck linting
if [[ "$(command -v shellcheck)" ]]; then
  echo "==> Shellcheck"
  pushd "${__root}" > /dev/null

  failed="false"

  while IFS=$'\n' read -r file; do
    [[ "${file}" =~ ^\./node_modules/ ]] && continue
    [[ "${file}" =~ ^\./website/\.lanyon/ ]] && continue

    echo -n "    ${file}.. "

    if ! shellcheck --shell=bash --external-sources --color=always \
      "${file}" >> "${__accptstTmpDir}/shellcheck.err"; then
        echo "✗"
        failed="true"
        continue
    fi

    echo "✓"
  done <<< "$(find . -type f -iname '*.sh')"

  popd > /dev/null

  if [[ "${failed}" = "true" ]]; then
    cat "${__accptstTmpDir}/shellcheck.err"
    exit 1
  fi
fi

# poor man's style guide checking
echo "==> b3bp style guide"
pushd "${__root}" > /dev/null

failed="false"

while IFS=$'\n' read -r file; do
  [[ "${file}" =~ ^\./node_modules/ ]] && continue
  [[ "${file}" =~ ^\./website/\.lanyon/ ]] && continue

  echo -n "    ${file}.. "

  if ! "${__root}/test/style.pl" "${file}" >> "${__accptstTmpDir}/style.err"; then
      echo "✗"
      failed="true"
      continue
  fi

  echo "✓"
done <<< "$(find . -type f -iname '*.sh')"

popd > /dev/null

if [[ "${failed}" = "true" ]]; then
  echo
  cat "${__accptstTmpDir}/style.err"
  echo
  exit 1
fi

exit 0
