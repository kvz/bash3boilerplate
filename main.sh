#!/usr/bin/env bash
# This file:
#
#  - Demos BASH3 Boilerplate (change this for your script)
#
# Usage:
#
#  LOG_LEVEL=7 ./main.sh -f /tmp/x -d (change this for your script)
#
# Based on a template by BASH3 Boilerplate v2.1.0
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

if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
  if [ ! -z ${__usage+x} ]; then
    __b3bp_external_usage="true"
    __b3bp_tmp_source_idx=1
  fi
else
  [ ! -z ${__usage+x} ] && unset __usage
  [ ! -z ${__helptext+x} ] && unset __helptext
fi

# Set magic variables for current file, directory, os, etc.
__dir="$(cd "$(dirname "${BASH_SOURCE[${__b3bp_tmp_source_idx:-0}]}")" && pwd)"
__file="${__dir}/$(basename "${BASH_SOURCE[${__b3bp_tmp_source_idx:-0}]}")"
__base="$(basename ${__file} .sh)"

# Define the environment variables (and their defaults) that this script depends on
LOG_LEVEL="${LOG_LEVEL:-6}" # 7 = debug -> 0 = emergency
NO_COLOR="${NO_COLOR:-}"    # true = disable color. otherwise autodetected


### Functions
##############################################################################

function __b3bp_log () {
  local log_level="${1}"
  shift

  local color_debug="\x1b[35m"
  local color_info="\x1b[32m"
  local color_notice="\x1b[34m"
  local color_warning="\x1b[33m"
  local color_error="\x1b[31m"
  local color_critical="\x1b[1;31m"
  local color_alert="\x1b[1;33;41m"
  local color_emergency="\x1b[1;4;5;33;41m"
  local colorvar="color_${log_level}"

  local color="${!colorvar:-$color_error}"
  local color_reset="\x1b[0m"

  if [ "${NO_COLOR}" = "true" ] || [[ "${TERM:-}" != "xterm"* ]] || [ -t 1 ]; then
    # Don't use colors on pipes or non-recognized terminals
    color=""; color_reset=""
  fi

  # all remaining arguments are to be printed
  local log_line=""

  while IFS=$'\n' read -r log_line; do
    echo -e "$(date -u +"%Y-%m-%d %H:%M:%S UTC") ${color}$(printf "[%9s]" ${log_level})${color_reset} $log_line" 1>&2
  done <<< "${@:-}"
}

function emergency () {                                $(__b3bp_log emergency "${@}") || true; exit 1; }
function alert ()     { [ "${LOG_LEVEL:-0}" -ge 1 ] && $(__b3bp_log alert "${@}") || true; }
function critical ()  { [ "${LOG_LEVEL:-0}" -ge 2 ] && $(__b3bp_log critical "${@}") || true; }
function error ()     { [ "${LOG_LEVEL:-0}" -ge 3 ] && $(__b3bp_log error "${@}") || true; }
function warning ()   { [ "${LOG_LEVEL:-0}" -ge 4 ] && $(__b3bp_log warning "${@}") || true; }
function notice ()    { [ "${LOG_LEVEL:-0}" -ge 5 ] && $(__b3bp_log notice "${@}") || true; }
function info ()      { [ "${LOG_LEVEL:-0}" -ge 6 ] && $(__b3bp_log info "${@}") || true; }
function debug ()     { [ "${LOG_LEVEL:-0}" -ge 7 ] && $(__b3bp_log debug "${@}") || true; }

function help () {
  echo "" 1>&2
  echo " ${@}" 1>&2
  echo "" 1>&2
  echo "  ${__usage:-No usage available}" 1>&2
  echo "" 1>&2

  if [ -n "${__helptext:-}" ]; then
    echo " ${__helptext}" 1>&2
    echo "" 1>&2
  fi

  exit 1
}


### Parse commandline options
##############################################################################

# Commandline options. This defines the usage page, and is used to parse cli
# opts & defaults from. The parsing is unforgiving so be precise in your syntax
# - A short option must be preset for every long option; but every short option
#   need not have a long option
# - `--` is respected as the separator between options and arguments
# - We do not bash-expand defaults, so setting '~/app' as a default will not resolve to ${HOME}.
#   you can use bash variables to work around this (so use ${HOME} instead)
[ -z ${__usage+x} ] && read -r -d '' __usage <<-'EOF' || true # exits non-zero when EOF encountered
  -f --file  [arg] Filename to process. Required.
  -t --temp  [arg] Location of tempfile. Default="/tmp/bar"
  -v               Enable verbose mode, print script as it is executed
  -d --debug       Enables debug mode
  -h --help        This page
  -n --no-color    Disable color output
  -1 --one         Do just one thing
EOF
[ -z ${__helptext+x} ] && read -r -d '' __helptext <<-'EOF' || true # exits non-zero when EOF encountered
 This is Bash3 Boilerplate's help text. Feel free to add any description of your
 program or elaborate more on command-line arguments. This section is not
 parsed and will be added as-is to the help.
EOF

# Translate usage string -> getopts arguments, and set $arg_<flag> defaults
while read __b3bp_tmp_line; do
  if echo "${__b3bp_tmp_line}" |egrep '^-' >/dev/null 2>&1; then
    # fetch single character version of option string
    __b3bp_tmp_opt="$(echo "${__b3bp_tmp_line}" |awk '{print $1}' |sed -e 's#^-##')"

    # fetch long version if present
    __b3bp_tmp_long_opt="$(echo "${__b3bp_tmp_line}" |awk '/\-\-/ {print $2}' |sed -e 's#^--##')"
    __b3bp_tmp_long_opt_mangled="$(sed 's#-#_#g' <<< $__b3bp_tmp_long_opt)"

    # map long name back to short name
    __b3bp_tmp_varname="__b3bp_tmp_short_opt_${__b3bp_tmp_long_opt_mangled}"
    eval "${__b3bp_tmp_varname}=\"${__b3bp_tmp_opt}\""

    # check if option takes an argument
    __b3bp_tmp_varname="__b3bp_tmp_has_arg_${__b3bp_tmp_opt}"
    if ! echo "${__b3bp_tmp_line}" |egrep '\[.*\]' >/dev/null 2>&1; then
      __b3bp_tmp_init="0" # it's a flag. init with 0
      eval "${__b3bp_tmp_varname}=0"
    else
      __b3bp_tmp_opt="${__b3bp_tmp_opt}:" # add : if opt has arg
      __b3bp_tmp_init=""  # it has an arg. init with ""
      eval "${__b3bp_tmp_varname}=1"
    fi
    __b3bp_tmp_opts="${__b3bp_tmp_opts:-}${__b3bp_tmp_opt}"
  fi

  [ -z "${__b3bp_tmp_opt:-}" ] && continue

  if echo "${__b3bp_tmp_line}" |egrep '\. Default=' >/dev/null 2>&1; then
    # ignore default value if option does not have an argument
    __b3bp_tmp_varname="__b3bp_tmp_has_arg_${__b3bp_tmp_opt:0:1}"

    if [ "${!__b3bp_tmp_varname}" = "1" ]; then
      __b3bp_tmp_init="$(echo "${__b3bp_tmp_line}" |sed 's#^.*Default=\(\)#\1#g')"
    fi
  fi

  __b3bp_tmp_varname="arg_${__b3bp_tmp_opt:0:1}"
  eval "${__b3bp_tmp_varname}=\"${__b3bp_tmp_init}\""
done <<< "${__usage:-}"

# run getopts only if options were specified in __usage
if [ -n "${__b3bp_tmp_opts:-}" ]; then
  # Allow long options like --this
  __b3bp_tmp_opts="${__b3bp_tmp_opts}-:"

  # Reset in case getopts has been used previously in the shell.
  OPTIND=1

  # start parsing command line
  set +o nounset # unexpected arguments will cause unbound variables
		 # to be dereferenced
  # Overwrite $arg_<flag> defaults with the actual CLI options
  while getopts "${__b3bp_tmp_opts}" __b3bp_tmp_opt; do
    [ "${__b3bp_tmp_opt}" = "?" ] && help "Invalid use of script: ${@} "

    if [ "${__b3bp_tmp_opt}" = "-" ]; then
      # OPTARG is long-option-name or long-option=value
      if [[ "${OPTARG}" =~ .*=.* ]]; then
	# --key=value format
	__b3bp_tmp_long_opt=${OPTARG/=*/}
	__b3bp_tmp_long_opt_mangled="$(sed 's#-#_#g' <<< $__b3bp_tmp_long_opt)"
	# Set opt to the short option corresponding to the long option
	eval "__b3bp_tmp_opt=\"\${__b3bp_tmp_short_opt_${__b3bp_tmp_long_opt_mangled}}\""
	OPTARG=${OPTARG#*=}
      else
	# --key value format
	# Map long name to short version of option
	__b3bp_tmp_long_opt_mangled="$(sed 's#-#_#g' <<< $OPTARG)"
	eval "__b3bp_tmp_opt=\"\${__b3bp_tmp_short_opt_${__b3bp_tmp_long_opt_mangled}}\""
	# Only assign OPTARG if option takes an argument
	eval "OPTARG=\"\${@:OPTIND:\${__b3bp_tmp_has_arg_${__b3bp_tmp_opt}}}\""
	# shift over the argument if argument is expected
	((OPTIND+=__b3bp_tmp_has_arg_${__b3bp_tmp_opt}))
      fi
      # we have set opt/OPTARG to the short value and the argument as OPTARG if it exists
    fi
    __b3bp_tmp_varname="arg_${__b3bp_tmp_opt:0:1}"
    __b3bp_tmp_default="${!__b3bp_tmp_varname}"

    __b3bp_tmp_value="${OPTARG}"
    if [ -z "${OPTARG}" ] && [ "${__b3bp_tmp_default}" = "0" ]; then
      __b3bp_tmp_value="1"
    fi

    eval "${__b3bp_tmp_varname}=\"${__b3bp_tmp_value}\""
    debug "cli arg ${__b3bp_tmp_varname} = ($__b3bp_tmp_default) -> ${!__b3bp_tmp_varname}"
  done
  set -o nounset # no more unbound variable references expected

  shift $((OPTIND-1))

  [ "${1:-}" = "--" ] && shift
fi


### Cleanup Environment variables
##############################################################################

for __tmp_varname in ${!__b3bp_tmp_*}; do
  eval "unset ${__tmp_varname}"
done

unset __tmp_varname


### Externally supplied __usage. Nothing else to do here
##############################################################################

if [ "${__b3bp_external_usage:-}" = "true" ]; then
  unset __b3bp_external_usage
  return
fi


### Command-line argument switches (like -d for debugmode, -h for showing helppage)
##############################################################################

# debug mode
if [ "${arg_d}" = "1" ]; then
  set -o xtrace
  LOG_LEVEL="7"
fi

# verbose mode
if [ "${arg_v}" = "1" ]; then
  set -o verbose
fi

# no color mode
if [ "${arg_n}" = "1" ]; then
  NO_COLOR="true"
fi

# help mode
if [ "${arg_h}" = "1" ]; then
  # Help exists with code 1
  help "Help using ${0}"
fi


### Validation. Error out if the things required for your script are not present
##############################################################################

[ -z "${arg_f:-}" ]     && help      "Setting a filename with -f or --file is required"
[ -z "${LOG_LEVEL:-}" ] && emergency "Cannot continue without LOG_LEVEL. "


### Runtime
##############################################################################

function cleanup_before_exit () {
  info "Cleaning up. Done"
}
trap cleanup_before_exit EXIT

info "__file: ${__file}"
info "__dir: ${__dir}"
info "__base: ${__base}"
info "OSTYPE: ${OSTYPE}"

info "arg_f: ${arg_f}"
info "arg_d: ${arg_d}"
info "arg_v: ${arg_v}"
info "arg_h: ${arg_h}"

info "$(echo -e "multiple lines example - line #1\nmultiple lines example - line #2\nimagine logging the output of 'ls -al /path/'")"

# All of these go to STDERR, so you can use STDOUT for piping machine readable information to other software
debug "Info useful to developers for debugging the application, not useful during operations."
info "Normal operational messages - may be harvested for reporting, measuring throughput, etc. - no action required."
notice "Events that are unusual but not error conditions - might be summarized in an email to developers or admins to spot potential problems - no immediate action required."
warning "Warning messages, not an error, but indication that an error will occur if action is not taken, e.g. file system 85% full - each item must be resolved within a given time. This is a debug message"
error "Non-urgent failures, these should be relayed to developers or admins; each item must be resolved within a given time."
critical "Should be corrected immediately, but indicates failure in a primary system, an example is a loss of a backup ISP connection."
alert "Should be corrected immediately, therefore notify staff who can fix the problem. An example would be the loss of a primary ISP connection."
emergency "A \"panic\" condition usually affecting multiple apps/servers/sites. At this level it would usually notify all tech staff on call."
