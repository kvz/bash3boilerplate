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
# Copyright (c) 2013 Kevin van Zonneveld and contributors
# http://bash3boilerplate.sh/#authors

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
__base="$(basename ${__file} .sh)"
__root="$(cd "$(dirname "${__dir}")" && pwd)"

scenarios="${1:-$(ls ${__dir}/scenario/|egrep -v ^prepare$)}"

__sysTmpDir="${TMPDIR:-/tmp}"
__sysTmpDir="${__sysTmpDir%/}" # <-- remove trailing slash on macosx
__accptstTmpDir="${__sysTmpDir}/accptst"
mkdir -p "${__accptstTmpDir}"

if [[ "${OSTYPE}" == "darwin"* ]]; then
  cmdSed=gsed
else
  cmdSed=sed
fi

if [[ "${OSTYPE}" == "darwin"* ]]; then
  cmdTimeout="gtimeout --kill-after=6m 5m"
else
  cmdTimeout="timeout --kill-after=6m 5m"
fi

__node="$(which node)"
__arch="amd64"


if ! which "${cmdSed}" > /dev/null; then
  echo "Please install ${cmdSed}"
  exit 1
fi

# Running prepare before other scenarios is important on Travis,
# so that stdio can diverge - and we can enforce stricter
# stdio comparison on all other tests.
for scenario in $(echo ${scenarios}); do
  echo "==> Scenario: ${scenario}"
  pushd "${__dir}/scenario/${scenario}" > /dev/null

    # Run scenario
    (${cmdTimeout} bash ./run.sh \
      > "${__accptstTmpDir}/${scenario}.stdio" 2>&1; \
      echo "${?}" > "${__accptstTmpDir}/${scenario}.exitcode" \
    ) || true

    # Clear out environmental specifics
    for typ in $(echo stdio exitcode); do
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

      if [ "$(cat "${curFile}" |grep 'ACCPTST:STDIO_REPLACE_IPS' |wc -l)" -gt 0 ]; then
        "${cmdSed}" -i \
          -r 's@[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}@{ip}@g' \
        "${curFile}"

        # IPs vary in length. Ansible uses padding. {ip} does not vary in length
        # so kill the padding after it for consistent output
        "${cmdSed}" -i \
          -r 's@\{ip\}\s+@{ip} @g' \
        "${curFile}"
      fi
      if [ "$(cat "${curFile}" |grep 'ACCPTST:STDIO_REPLACE_UUIDS' |wc -l)" -gt 0 ]; then
        "${cmdSed}" -i \
          -r 's@[0-9a-f\-]{32,40}@{uuid}@g' \
        "${curFile}"
      fi
      if [ "$(cat "${curFile}" |grep 'ACCPTST:STDIO_REPLACE_BIGINTS' |wc -l)" -gt 0 ]; then
        # Such as: 3811298194
        "${cmdSed}" -i \
          -r 's@[0-9]{7,64}@{bigint}@g' \
        "${curFile}"
      fi
      if [ "$(cat "${curFile}" |grep 'ACCPTST:STDIO_REPLACE_DATETIMES' |wc -l)" -gt 0 ]; then
        # Such as: 2016-02-10 15:38:44.420094
        "${cmdSed}" -i \
          -r 's@[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}@{datetime}@g' \
        "${curFile}"
      fi
      if [ "$(cat "${curFile}" |grep 'ACCPTST:STDIO_REPLACE_LONGTIMES' |wc -l)" -gt 0 ]; then
        # Such as: 2016-02-10 15:38:44.420094
        "${cmdSed}" -i \
          -r 's@[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{6}@{longtime}@g' \
        "${curFile}"
      fi
      if [ "$(cat "${curFile}" |grep 'ACCPTST:STDIO_REPLACE_DURATIONS' |wc -l)" -gt 0 ]; then
        # Such as: 0:00:00.001991
        "${cmdSed}" -i \
          -r 's@[0-9]{1,2}:[0-9]{2}:[0-9]{2}.[0-9]{6}@{duration}@g' \
        "${curFile}"
      fi
      if [ "$(cat "${curFile}" |grep 'ACCPTST:STDIO_REPLACE_REMOTE_EXEC' |wc -l)" -gt 0 ]; then
        egrep -v 'remote-exec\): [ a-zA-Z]' "${curFile}" > "${__sysTmpDir}/accptst-filtered.txt"
        mv "${__sysTmpDir}/accptst-filtered.txt" "${curFile}"
      fi
    done

    # Save these as new fixtures?
    if [ "${SAVE_FIXTURES:-}" = "true" ]; then
      for typ in $(echo stdio exitcode); do
        curFile="${__accptstTmpDir}/${scenario}.${typ}"
        cp -f \
          "${curFile}" \
          "${__dir}/fixture/${scenario}.${typ}"
      done
    fi

    # Compare
    for typ in $(echo stdio exitcode); do
      curFile="${__accptstTmpDir}/${scenario}.${typ}"

      echo -n "    comparing ${typ}.. "

      if [ "${typ}" = "stdio" ]; then
        if [ "$(cat "${curFile}" |grep 'ACCPTST:STDIO_SKIP_COMPARE' |wc -l)" -gt 0 ]; then
          echo "skip"
          continue
        fi
      fi

      if ! diff --strip-trailing-cr "${__dir}/fixture/${scenario}.${typ}" "${curFile}"; then
        echo -e "\n\n==> MISMATCH OF: ${scenario}.${typ} ---^"
        echo -e "\n\n==> EXPECTED STDIO: "
        cat "${__dir}/fixture/${scenario}.stdio" || true
        echo -e "\n\n==> ACTUAL STDIO: "
        cat "${__accptstTmpDir}/${scenario}.stdio" || true
        exit 1
      fi

      echo "✓"
    done

  popd > /dev/null
done
