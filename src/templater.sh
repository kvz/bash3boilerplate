#!/usr/bin/env bash
# BASH3 Boilerplate: templater
#
# This file:
#
#  - takes a source (template) & destination (config) filepath argument
#  - then replaces placeholders with variables found in the environment
#
# Usage as a function:
#
#  source templater.sh
#  export NAME=kevin
#  templater input.cfg output.cfg
#
# Usage as a command:
#
#  ALLOW_REMAINDERS=1 templater.sh input.cfg output.cfg
#
# Based on a template by BASH3 Boilerplate v[31m[1mUnknown Syntax Error[22m[39m: Command not found; did you mean one of:

  0. yarn cache clean [--mirror] [--all]
  1. yarn cache clean [--mirror] [--all]
  2. yarn config get [--json] [--no-redacted] <name>
  3. yarn config set [--json] [-H,--home] <name> <value>
  4. yarn config unset [-H,--home] <name>
  5. yarn set resolution [-s,--save] <descriptor> <resolution>
  6. yarn set version from sources [--path #0] [--repository #0] [--branch #0] [--plugin #0] [--no-minify] [-f,--force] [--skip-plugins]
  7. yarn set version [--only-if-needed] <version>
  8. yarn workspaces list [--since] [-R,--recursive] [--no-private] [-v,--verbose] [--json]
  9. yarn --clipanion=definitions
 10. yarn help
 11. yarn help
 12. yarn help
 13. yarn <leadingArgument> ...
 14. yarn -v
 15. yarn -v
 16. yarn bin [-v,--verbose] [--json] [name]
 17. yarn config [-v,--verbose] [--why] [--json]
 18. yarn dedupe [-s,--strategy #0] [-c,--check] [--json] [--mode #0] ...
 19. yarn exec <commandName> ...
 20. yarn explain peer-requirements [hash]
 21. yarn explain [--json] [code]
 22. yarn info [-A,--all] [-R,--recursive] [-X,--extra #0] [--cache] [--dependents] [--manifest] [--name-only] [--virtuals] [--json] ...
 23. yarn install [--json] [--immutable] [--immutable-cache] [--check-cache] [--inline-builds] [--mode #0]
 24. yarn link [-A,--all] [-p,--private] [-r,--relative] <destination>
 25. yarn unlink [-A,--all] ...
 26. yarn node ...
 27. yarn plugin import from sources [--path #0] [--repository #0] [--branch #0] [--no-minify] [-f,--force] <name>
 28. yarn plugin import <name>
 29. yarn plugin remove <name>
 30. yarn plugin list [--json]
 31. yarn plugin runtime [--json]
 32. yarn rebuild ...
 33. yarn remove [-A,--all] [--mode #0] ...
 34. yarn run
 35. yarn up [-i,--interactive] [-E,--exact] [-T,--tilde] [-C,--caret] [-R,--recursive] [--mode #0] ...
 36. yarn why [-R,--recursive] [--json] [--peers] <package>
 37. yarn workspace <workspaceName> <commandName> ...
 38. yarn create [-p,--package #0] [-q,--quiet] <command> ...
 39. yarn dlx [-p,--package #0] [-q,--quiet] <command> ...
 40. yarn init [-p,--private] [-w,--workspace] [-i,--install]
 41. yarn npm audit [-A,--all] [-R,--recursive] [--environment #0] [--json] [--severity #0] [--exclude #0] [--ignore #0]
 42. yarn npm info [-f,--fields #0] [--json] ...
 43. yarn npm login [-s,--scope #0] [--publish] [--always-auth]
 44. yarn npm logout [-s,--scope #0] [--publish] [-A,--all]
 45. yarn npm publish [--access #0] [--tag #0] [--tolerate-republish] [--otp #0]
 46. yarn npm tag add <package> <tag>
 47. yarn npm tag list [--json] [package]
 48. yarn npm tag remove <package> <tag>
 49. yarn npm whoami [-s,--scope #0] [--publish]
 50. yarn pack [--install-if-needed] [-n,--dry-run] [--json] [-o,--out #0]
 51. yarn patch-commit [-s,--save] <patchFolder>
 52. yarn patch [--json] <package>
 53. yarn unplug [-A,--all] [-R,--recursive] [--json] ...

While running --silent version:current
# http://bash3boilerplate.sh/#authors
#
# The MIT License (MIT)
# Copyright (c) 2013 Kevin van Zonneveld and contributors
# You are not obligated to bundle the LICENSE file with your b3bp projects as long
# as you leave these references intact in the header comments of your source files.

function templater() {
  ALLOW_REMAINDERS="${ALLOW_REMAINDERS:-0}"

  templateSrc="${1:-}"
  templateDst="${2:-}"

  if [[ ! -f "${templateSrc}" ]]; then
    echo "ERROR: Template source '${templateSrc}' needs to exist"
    exit 1
  fi
  if [[ ! "${templateDst}" ]]; then
    echo "ERROR: Template destination '${templateDst}' needs to be specified"
    exit 1
  fi

  if [[ "$(command -v perl)" ]]; then
    perl -p -e 's/\$\{(\w+)\}/(exists $ENV{$1} ? $ENV{$1} : "\${$1}")/eg' < "${templateSrc}" > "${templateDst}"
  else
    cp -f "${templateSrc}" "${templateDst}"

    for var in $(env |awk -F= '{print $1}' |grep -E '^(_[A-Z0-9_]+|[A-Z0-9][A-Z0-9_]*)$'); do
      sed -i.bak -e "s#\${${var}}#${!var//#/\\#/}#g" "${templateDst}"
      # this .bak dance is done for BSD/GNU portability: http://stackoverflow.com/a/22084103/151666
      rm -f "${templateDst}.bak"
    done
  fi

  # cat "${templateDst}"

  # shellcheck disable=SC2016
  if grep '${' "${templateDst}" && [[ "${ALLOW_REMAINDERS}" = "0" ]]; then
    echo "ERROR: Unable to replace the above template vars"
    exit 1
  fi
}

if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  export -f templater
else
  templater "${@}"
  exit ${?}
fi
