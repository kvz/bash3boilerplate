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

. set_environment_and_color

# Incorporate the bash3boilerplate content that does not need to change from one use to the next
# and designate the name of the file containing the current file's usage as the file with "-usage"
# appended to the current file's name:
__filename="$(basename "${BASH_SOURCE[0]}")"
usage_page="${__filename}-usage"

# Command-Line Interface (CLI) 
# ----------------------------
# This 'while' block below reads the file named in usage_page, which will also be used to 
# parse CLI options, their associated arguments, their default values, and their status as
# required or optional.  See the above-referenced bootstrap script for a comprehensive 
# example of usage page contents.  See my-script.sh-usage for the specific usage page for
# the current script.
while IFS='' read -r line || [[ -n "$line" ]]; do
  usage="${usage:-}""${line}"$'\n'
done < "${usage_page}"

. define_functions

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

. parse_command_line
parse $@

. set_common_switches

### Validation (decide what's required for running your script and error out)
#####################################################################

[ -z "${LOG_LEVEL:-}" ] && emergency "Cannot continue without LOG_LEVEL. "

### Runtime
#####################################################################

info "__file: ${__file}"
info "__dir: ${__dir}"
info "__base: ${__base}"
info "__os: ${__os}"

info "arg_p: ${arg_p}"
info "arg_d: ${arg_d}"
info "arg_v: ${arg_v}"
info "arg_V: ${arg_V}"
info "arg_h: ${arg_h}"
