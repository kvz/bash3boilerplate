[![Build Status](https://travis-ci.org/kvz/bash3boilerplate.svg?branch=master)](https://travis-ci.org/kvz/bash3boilerplate)

When hacking up BASH scripts, I often find there are some
higher level things like logging, configuration, command-line argument
parsing that:

 - I need every time
 - Take quite some effort to get right
 - Keep you from your actual work

Here's an attempt to bundle those things in a generalized way so that
they are reusable as-is in most of my (and hopefully your, if not ping
me) programs.

## Goals

Delete-key-friendly. I propose using `main.sh` as a base and removing the
parts you don't need, rather than introducing a ton of packages, includes, compilers, etc.

Aiming for portability, I'm targeting Bash 3 (OSX still ships
with 3 for instance). If you're going to ask people to install
Bash 4 first, you might as well pick a more advanced language as a
dependency.

We're automatically testing bash3boilerplate and it's proven to work on:

- [Linux](https://travis-ci.org/kvz/bash3boilerplate/jobs/109804166#L91) `GNU bash, version 4.2.25(1)-release (x86_64-pc-linux-gnu)`
- [OSX](https://travis-ci.org/kvz/bash3boilerplate/jobs/109804167#L2453) `GNU bash, version 3.2.51(1)-release (x86_64-apple-darwin13)`

## Features

- Structure
- Safe defaults (break on error, pipefail, etc)
- Configuration by environment variables
- Configuration by command-line arguments (definitions parsed from help info,
  so no duplication needed)
- Magic variables like `__file` and `__dir`
- Logging that supports colors and is compatible with [Syslog Severity levels](http://en.wikipedia.org/wiki/Syslog#Severity_levels)

## Installation

There are 3 ways you can install (parts of) b3bp:

1. Just get the main template: `wget https://raw.githubusercontent.com/kvz/bash3boilerplate/master/main.sh`
2. Clone the entire project: `git clone git@github.com:kvz/bash3boilerplate.git`
3. As of `v1.0.3`, b3bp can be installed as a `package.json` dependency via: `npm install --save bash3boilerplate`

Although *3* introduces a node.js dependency, this does allow for easy version pinning and distribution in environments that already have this prerequisite. But nothing prevents you from just using `curl` and keep your project or build system low on external dependencies.

## Changelog

### master (Unreleased)

- Fix Travis OSX testing (before, it would silently pass failures) (#10)
- Enable dashes in long, GNU style options, as well as numbers (thanks @zbeekman)

### v2.0.0 (2016-02-17)

- Add tests for `templater` and follow Library export best practices
- Add tests for `ini_val` and follow Library export best practices
- Add tests for `parse_url` and follow Library export best practices
- Add tests for `megamount` and follow Library export best practices
- Remove `bump` from `src` (BREAKING)
- Remove `semver` from `src` (BREAKING)

### v1.2.1 (2016-02-17)

- Add Travis CI automated testing for OSX (thanks @zbeekman)

### v1.2.0 (2016-02-16)

- Allow disabling colors via `NO_COLOR` environment variable
- Enable `errexit`, `nounset` and `pipefail` options at the top of the script already
- More refined colors (thanks @arathai)
- Add a changelog to the README
- Add `__os` magic var (limited to discovering OSX and defaulting to Linux for now)
- Add `__base` magic var (`main`, if the source script is `main.sh`)
- Enable long, GNU style options (thanks @zbeekman)
- Add Travis CI automated testing for Linux

### v1.1.0 (2015-06-29)

- Add `ALLOW_REMAINDERS` configuration to templater
- Fix typo: 'debugmdoe' to 'debugmode' (thanks @jokajak)
- Use `${BASH_SOURCE[0]}` for `__file` instead of `${0}`

### v1.0.3 (2014-11-02)

- Add `ini_val`, `megamount`, `parse_url`
- Add re-usable libraries in `./src`
- Use npm as an additional distribution channel

## Best practices

As of `v1.0.3`, b3bp adds some nice re-usable libraries in `./src`. Later on we'll be using snippets inside this directory to build custom packages. In order to make the snippets in `./src` more useful, we recommend these guidelines.

### Library exports

It's nice to have a bash package that can be used in the terminal and also be invoked as a command line function. To achieve this the exporting of your functionality *should* follow this pattern:

```bash
if [ "${BASH_SOURCE[0]}" != ${0} ]; then
  export -f my_script
else
  my_script "${@}"
  exit $?
fi
```

This allows a user to `source` your script or invoke as a script.

```bash
# Running as a script
$ ./my_script.sh some args --blah
# Sourcing the script
$ source my_script.sh
$ my_script some more args --blah
```

(taken from the [bpkg](https://raw.githubusercontent.com/bpkg/bpkg/master/README.md) project)

### Miscellaneous

- In functions, use `local` before every variable declaration
- This project settles on two spaces for tabs

## Authors

- Kevin van Zonneveld (<http://kvz.io>)
- Izaak Beekman (<https://izaakbeekman.com/>)
- Alexander Rathai (<Alexander.Rathai@gmail.com>)

## Sponsoring

<!-- badges/ -->
[![Flattr donate button](http://img.shields.io/flattr/donate.png?color=green)](https://flattr.com/submit/auto?user_id=kvz&url=https://github.com/kvz/bash3boilerplate&title=bash3boilerplate&language=&tags=github&category=software "Sponsor the development of bash3boilerplate via Flattr")
<!-- /badges -->

## License

Copyright (c) 2013 Kevin van Zonneveld, [http://kvz.io](http://kvz.io)  
Licensed under MIT: [http://kvz.io/licenses/LICENSE-MIT](http://kvz.io/licenses/LICENSE-MIT)
