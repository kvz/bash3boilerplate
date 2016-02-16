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

Delete-key-friendly. I propose people use `main.sh` as a base and remove the
parts they don't need, rather than introducing a ton of packages, includes, compilers, etc.

Aiming for portability, I'm targeting Bash 3 (OSX still ships
with 3 for instance). If you're going to ask people to install
Bash 4 first, you might as well pick a more advanced language as a
dependency.

## Features

- Structure
- Configuration by environment variables
- Configuration by command-line arguments (definitions parsed from help info,
  so no duplication needed)
- Magic variables like `__file__` and `__dir__`
- Logging that supports colors and is compatible with [Syslog Severity levels](http://en.wikipedia.org/wiki/Syslog#Severity_levels)

## Installation

There are 3 ways you can install (parts of) b3bp:

 1. Just get the main template: `wget https://raw.githubusercontent.com/kvz/bash3boilerplate/master/main.sh`
 2. Clone the entire project: `git clone git@github.com:kvz/bash3boilerplate.git`
 3. As of `v1.0.3`, b3bp can be installed as a `package.json` dependency via: `npm install --save bash3boilerplate`

Although `3` introduces a node.js dependency, this does allow for easy version pinning & distrubtions in environments that already have this prerequisite. But nothing prevents you from just using `curl` and keep your project or build system low on external dependencies.

## Versioning

This project implements the Semantic Versioning guidelines.

Releases will be numbered with the following format:

`<major>.<minor>.<patch>`

And constructed with the following guidelines:

* Breaking backward compatibility bumps the major (and resets the minor and patch)
* New additions without breaking backward compatibility bumps the minor (and resets the patch)
* Bug fixes and misc changes bumps the patch

For more information on SemVer, please visit [http://semver.org](http://semver.org).

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

## Todo

 - [ ] Make `src` libs adhere to Best practices
 - [ ] `make build` system for generating custom builds
 - [ ] tests & releases via Travis

## Sponsoring

<!-- badges/ -->
[![Gittip donate button](http://img.shields.io/gittip/kvz.png)](https://www.gittip.com/kvz/ "Sponsor the development of bash3boilerplate via Gittip")
[![Flattr donate button](http://img.shields.io/flattr/donate.png?color=yellow)](https://flattr.com/submit/auto?user_id=kvz&url=https://github.com/kvz/bash3boilerplate&title=bash3boilerplate&language=&tags=github&category=software "Sponsor the development of bash3boilerplate via Flattr")
[![PayPayl donate button](http://img.shields.io/paypal/donate.png?color=yellow)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=kevin%40vanzonneveld%2enet&lc=NL&item_name=Open%20source%20donation%20to%20Kevin%20van%20Zonneveld&currency_code=USD&bn=PP-DonationsBF%3abtn_donate_SM%2egif%3aNonHosted "Sponsor the development of bash3boilerplate via Paypal")
[![BitCoin donate button](http://img.shields.io/bitcoin/donate.png?color=yellow)](https://coinbase.com/checkouts/19BtCjLCboRgTAXiaEvnvkdoRyjd843Dg2 "Sponsor the development of bash3boilerplate via BitCoin")
<!-- /badges -->

## License

Copyright (c) 2013 Kevin van Zonneveld, [http://kvz.io](http://kvz.io)  
Licensed under MIT: [http://kvz.io/licenses/LICENSE-MIT](http://kvz.io/licenses/LICENSE-MIT)
