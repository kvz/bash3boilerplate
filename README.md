<!-- badges/ -->
[![Build Status](https://travis-ci.org/kvz/bash3boilerplate.svg?branch=master)](https://travis-ci.org/kvz/bash3boilerplate)
<!-- /badges -->
[This document is formatted with GitHub-Flavored Markdown.    ]:#
[For better viewing, including hyperlinks, read it online at  ]:#
[https://github.com/kvz/bash3boilerplate/blob/master/README.md]:#

* [Overview](#overview)
* [Goals](#goals)
* [Features](#features)
* [Installation](#installation)
* [Changelog](#changelog)
* [Best Practices](#best-practices)
* [Frequently Asked Questions](#frequently-asked-questions)
* [Authors](#authors)
* [License](#license)

## Overview

<!--more-->

When hacking up Bash scripts, there are often higher level things like logging, 
configuration, command-line argument parsing that:

 - You need every time
 - Come with a number of pitfalls to get right
 - Keep you from your actual work

Here's an attempt to bundle those things in a generalized way so that
they are reusable as-is in most scripts.

## Goals

Delete-key-friendly. I propose using [`main.sh`](./main.sh) as a base and removing the
parts you don't need, rather than introducing a ton of packages, includes, compilers, etc.

Aiming for portability, I'm targeting Bash 3 (OSX still ships
with 3 for instance). If you're going to ask people to install
Bash 4 first, you might as well pick a more advanced language as a
dependency.

We're automatically testing BASH3 Boilerplate and it's proven to work on:

- [Linux](https://travis-ci.org/kvz/bash3boilerplate/jobs/109804166#L91) `GNU bash, version 4.2.25(1)-release (x86_64-pc-linux-gnu)`
- [OSX](https://travis-ci.org/kvz/bash3boilerplate/jobs/109804167#L2453) `GNU bash, version 3.2.51(1)-release (x86_64-apple-darwin13)`

## Features

- Structure
- Safe defaults (break on error, pipefail, etc)
- Configuration by environment variables
- Configuration by command-line arguments (definitions parsed from help info,
  so no duplication needed)
- Magic variables like `__file`, `__dir`, and `__os`
- Logging that supports colors and is compatible with [Syslog Severity levels](http://en.wikipedia.org/wiki/Syslog#Severity_levels) as well as the [The twelve-factor app](http://12factor.net/)

## Installation

There are 3 ways you can install (parts of) b3bp:

1. Just get the main template: `wget https://raw.githubusercontent.com/kvz/bash3boilerplate/master/main.sh`
2. Clone the entire project: `git clone git@github.com:kvz/bash3boilerplate.git`
3. As of `v1.0.3`, b3bp can be installed as a `package.json` dependency via: `npm install --save bash3boilerplate`

Although *3* introduces a node.js dependency, this does allow for easy version pinning and distribution in environments that already have this prerequisite. But nothing prevents you from just using `curl` and keep your project or build system low on external dependencies.

## Changelog

Please see the [CHANGELOG.md](./CHANGELOG.md) file.

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

## Frequently Asked Questions

Please see the [FAQ.md](./FAQ.md) file.

## Authors

- [Kevin van Zonneveld](http://kvz.io)
- [Izaak Beekman](https://izaakbeekman.com/)
- [Alexander Rathai](mailto:<Alexander.Rathai@gmail.com>)
- [Dr. Damian Rouson](http://www.sourceryinstitute.org/) (documentation, feedback)
- [@jokajak](https://github.com/jokajak) (documentation)
- [Gabriel A. Devenyi](http://staticwave.ca/) (feedback)
- [@bravo-kernel](https://github.com/bravo-kernel) (feedback)

## License

Copyright (c) 2013 Kevin van Zonneveld and [contributors](https://github.com/kvz/bash3boilerplate#authors).
Licensed under [MIT](https://raw.githubusercontent.com/kvz/bash3boilerplate/master/LICENSE).
You are not obligated to bundle the LICENSE file with your b3bp projects as long
as you leave these references intact.
