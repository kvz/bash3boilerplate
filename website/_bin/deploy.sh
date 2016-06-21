#!/usr/bin/env bash
set -o pipefail
set -o errexit
set -o nounset
# set -o xtrace

# Set magic variables for current file & dir
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"

ghpages_repo=${GHPAGES_REPO:-"kvz/bash3boilerplate"}
ghpages_branch=${GHPAGES_BRANCH:-"gh-pages"}
ghpages_url=${GHPAGES_URL:-"git@github.com:${ghpages_repo}.git"}

echo "--> Deploying to GitHub pages.."

${__dir}/build.sh

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
