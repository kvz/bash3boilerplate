#!/usr/bin/env bash
# This file:
#
#  - Let's inject.sh inject markdown files into the ./website directory
#  - Syncs that to a temporary directory along with a git init
#  - (in case of Travis CI) assumes a Git bot identity, and uses an overriden GHPAGES_URL containing its token thanks to `travis encrypt`
#  - Force pushes that to the gh-pages branch
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
__os="Linux"
if [[ "${OSTYPE:-}" == "darwin"* ]]; then
  __os="OSX"
fi

ghpages_repo=${GHPAGES_REPO:-"kvz/bash3boilerplate"}
ghpages_branch=${GHPAGES_BRANCH:-"gh-pages"}
ghpages_url=${GHPAGES_URL:-"git@github.com:${ghpages_repo}.git"}

echo "--> Deploying to GitHub pages.."

${__dir}/inject.sh

if [ "${TRAVIS:-}" = "true" ]; then
  git config --global user.name 'lekevbot'
  git config --global user.email 'bot@kvz.io'
fi

mkdir -p /tmp/deploy-${ghpages_repo}

# Custom steps
rsync \
  --archive \
  --delete \
  --exclude=.git* \
  --exclude=node_modules \
  --exclude=lib \
  --checksum \
  --no-times \
  --no-group \
  --no-motd \
  --no-owner \
./website/ /tmp/deploy-${ghpages_repo} > /dev/null

echo 'This branch is just a deploy target. Do not edit. You changes will be lost.' \
  |tee /tmp/deploy-${ghpages_repo}/README.md

(cd /tmp/deploy-${ghpages_repo} \
  && git init && git checkout -B ${ghpages_branch} && git add --all . \
  && git commit -nm "Update ${ghpages_repo} website by ${USER}" \
  && (git remote add origin ${ghpages_url}|| true)  \
  && git push origin ${ghpages_branch}:refs/heads/${ghpages_branch} --force) > /dev/null

rm -rf /tmp/deploy-${ghpages_repo}
