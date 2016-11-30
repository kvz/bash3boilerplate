#!/usr/bin/env bash
# This file:
#
#  - Builds website for production
#  - Force pushes that to the gh-pages branch
#  - On travis, make sure you have encrypted the GHPAGES_URL var
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

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail
set -o xtrace

echo "--> Deploying to GitHub pages.."

if [ "${TRAVIS:-}" = "true" ]; then
  git config --global user.name 'lekevbot'
  git config --global user.email 'bot@kvz.io'
fi

if type yarn; then
  yarn
else
  npm install
fi

npm run web:build:production

pushd website/_site
  [ -d .git ] || git init
  echo 'This branch is just a deploy target. Do not edit. You changes will be lost.' |tee README.md
  git checkout -B gh-pages
  git add --all .
  git commit -nm "Update website by ${USER}" || true
  git remote add origin ${GHPAGES_URL} || true
  git push origin gh-pages:refs/heads/gh-pages || git push origin gh-pages:refs/heads/gh-pages --force > /dev/null
popd
