#!/usr/bin/env bash
# BASH3 Boilerplate
#
# This file:
#
#  - Is a template to write better bash scripts
#  - Is delete-key friendly, in case you don't need e.g. command line option parsing
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
#  - Izaak Beekman (https://izaakbeekman.com/)
#  - Alexander Rathai (Alexander.Rathai@gmail.com)
#  - Dr. Damian Rouson (http://www.sourceryinstitute.org/) (documentation)
#
# Usage:
#
#  LOG_LEVEL=7 ./main.sh -f /tmp/x -d
#
# Licensed under MIT
# Copyright (c) 2013 Kevin van Zonneveld (http://kvz.io)


### Configuration
#####################################################################

# Exit on error. Append ||true if you expect an error.
# `set` is safer than relying on a shebang like `#!/bin/bash -e` because that is neutralized
# when someone runs your script as `bash yourscript.sh`
set -o errexit
set -o nounset

# Bash will remember & return the highest exitcode in a chain of pipes.
# This way you can catch the error in case mysqldump fails in `mysqldump |gzip`
set -o pipefail
# set -o xtrace

# Environment variables and their defaults
LOG_LEVEL="${LOG_LEVEL:-6}" # 7 = debug -> 0 = emergency
NO_COLOR="${NO_COLOR:-}"    # true = disable color. otherwise autodetected

# Commandline options. This defines the usage page, and is used to parse cli
# opts & defaults from. The parsing is unforgiving so be precise in your syntax
# - A short option must be preset for every long option; but every short option
#   need not have a long option
# - `--` is respected as the separator between options and arguments
read -r -d '' usage <<-'EOF' || true # exits non-zero when EOF encountered
  -f --file  [arg] Filename to process. Required.
  -t --temp  [arg] Location of tempfile. Default="/tmp/bar"
  -V               Enable verbose mode, print script as it is executed
  -v --version     Print software version number.
  -d --debug       Enables debug mode
  -h --help        This page
  -n --no-color    Disable color output
  -1 --one         Do just one thing
EOF

# Set magic variables for current file and its directory.
# BASH_SOURCE[0] is used so we can display the current file even if it is sourced by a parent script.
# If you need the script that was executed, consider using $0 instead.
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[0]}")"
__base="$(basename ${__file} .sh)"
__os="Linux"
if [[ "${OSTYPE:-}" == "darwin"* ]]; then
  __os="OSX"
fi

. define_functions

. parse_command_line
parse_command_line $@

. set_common_switches

### Validation (decide what's required for running your script and error out)
#####################################################################

[ -z "${arg_f:-}" ]     && help      "Setting a filename with -f or --file is required"
[ -z "${LOG_LEVEL:-}" ] && emergency "Cannot continue without LOG_LEVEL. "


### Runtime
#####################################################################

info "__file: ${__file}"
info "__dir: ${__dir}"
info "__base: ${__base}"
info "__os: ${__os}"

info "arg_f: ${arg_f}"
info "arg_d: ${arg_d}"
info "arg_v: ${arg_v}"
info "arg_h: ${arg_h}"

usage_page="${arg_f}"
info "bootstrap complete: \$usage_page=${usage_page}"
