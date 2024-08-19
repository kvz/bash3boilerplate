[This document is formatted with GitHub-Flavored Markdown. ]: #
[For better viewing, including hyperlinks, read it online at ]: #
[https://github.com/kvz/bash3boilerplate/blob/HEAD/README.md]: #

- [Overview](#overview)
- [Goals](#goals)
- [Features](#features)
- [Installation](#installation)
- [Changelog](#changelog)
- [Frequently Asked Questions](#frequently-asked-questions)
- [Best Practices](#best-practices)
- [Who uses b3bp](#who-uses-b3bp)
- [Authors](#authors)
- [License](#license)

## Overview

<!--more-->

When hacking up Bash scripts, there are often things such as logging or command-line argument parsing that:

- You need every time
- Come with a number of pitfalls you want to avoid
- Keep you from your actual work

Here's an attempt to bundle those things in a generalized way so that
they are reusable as-is in most scripts.

We call it "BASH3 Boilerplate" or b3bp for short.

## Goals

Delete-Key-**Friendly**. Instead of introducing packages, includes, compilers, etc., we propose using [`main.sh`](https://bash3boilerplate.sh/main.sh) as a base and removing the parts you don't need.
While this may feel a bit archaic at first, it is exactly the strength of Bash scripts that we should want to embrace.

**Portable**. We are targeting Bash 3 (OSX still ships
with 3, for instance). If you are going to ask people to install
Bash 4 first, you might as well pick a more advanced language as a
dependency.

## Features

- Conventions that will make sure that all your scripts follow the same, battle-tested structure
- Safe by default (break on error, pipefail, etc.)
- Configuration by environment variables
- Simple command-line argument parsing that requires no external dependencies. Definitions are parsed from help info, ensuring there will be no duplication
- Helpful magic variables like `__file` and `__dir`
- Logging that supports colors and is compatible with [Syslog Severity levels](https://en.wikipedia.org/wiki/Syslog#Severity_levels), as well as the [twelve-factor](https://12factor.net/) guidelines

## Installation

There are three different ways to install b3bp:

### Option 1: Download the main template

Use curl or wget to download the source and save it as your script. Then you can start deleting the unwanted bits, and adding your own logic.

```bash
wget https://bash3boilerplate.sh/main.sh
vim main.sh
```

### Option 2: Clone the entire project

Besides `main.sh`, this will also get you the entire b3bp repository. This includes a few extra functions that we keep in the `./src` directory.

```bash
git clone git@github.com:kvz/bash3boilerplate.git
```

### Option 3: Require via npm

As of `v1.0.3`, b3bp can also be installed as a Node module, meaning you can define it as a dependency in `package.json` via:

```bash
npm init
npm install --save --save-exact bash3boilerplate
```

Even though this option introduces a Node.js dependency, it does allow for easy version pinning and distribution in environments that already have this prerequisite. This is, however, entirely optional and nothing prevents you from ignoring this possibility.

## Changelog

Please see the [CHANGELOG.md](./CHANGELOG.md) file.

## Frequently Asked Questions

Please see the [FAQ.md](./FAQ.md) file.

## Best practices

As of `v1.0.3`, b3bp offers some nice re-usable libraries in `./src`. In order to make the snippets in `./src` more useful, we recommend the following guidelines.

### Function packaging

It is nice to have a Bash package that can not only be used in the terminal, but also invoked as a command line function. In order to achieve this, the exporting of your functionality _should_ follow this pattern:

```bash
if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
  my_script "${@}"
  exit $?
fi
export -f my_script
```

This allows a user to `source` your script or invoke it as a script.

```bash
# Running as a script
$ ./my_script.sh some args --blah
# Sourcing the script
$ source my_script.sh
$ my_script some more args --blah
```

(taken from the [bpkg](https://raw.githubusercontent.com/bpkg/bpkg/HEAD/README.md) project)

### Scoping

1. In functions, use `local` before every variable declaration.
1. Use `UPPERCASE_VARS` to indicate environment variables that can be controlled outside your script.
1. Use `__double_underscore_prefixed_vars` to indicate global variables that are solely controlled inside your script, with the exception of arguments that are already prefixed with `arg_`, as well as functions, over which b3bp poses no restrictions.

### Coding style

1. Use two spaces for tabs, do not use tab characters.
1. Do not introduce whitespace at the end of lines or on blank lines as they obfuscate version control diffs.
1. Use long options (`logger --priority` vs `logger -p`). If you are on the CLI, abbreviations make sense for efficiency. Nevertheless, when you are writing reusable scripts, a few extra keystrokes will pay off in readability and avoid ventures into man pages in the future, either by you or your collaborators. Similarly, we prefer `set -o nounset` over `set -u`.
1. Use a single equal sign when checking `if [[ "${NAME}" = "Kevin" ]]`; double or triple signs are not needed.
1. Use the new bash builtin test operator (`[[ ... ]]`) rather than the old single square bracket test operator or explicit call to `test`.

### Safety and Portability

1. Use `{}` to enclose your variables. Otherwise, Bash will try to access the `$ENVIRONMENT_app` variable in `/srv/$ENVIRONMENT_app`, whereas you probably intended `/srv/${ENVIRONMENT}_app`. Since it is easy to miss cases like this, we recommend that you make enclosing a habit.
1. Use `set`, rather than relying on a shebang like `#!/usr/bin/env bash -e`, since that is neutralized when someone runs your script as `bash yourscript.sh`.
1. Use `#!/usr/bin/env bash`, as it is more portable than `#!/bin/bash`.
1. Use `${BASH_SOURCE[0]}` if you refer to current file, even if it is sourced by a parent script. In other cases, use `${0}`.
1. Use `:-` if you want to test variables that could be undeclared. For instance, with `if [[ "${NAME:-}" = "Kevin" ]]`, `$NAME` will evaluate to `Kevin` if the variable is empty. The variable itself will remain unchanged. The syntax to assign a default value is `${NAME:=Kevin}`.

## Who uses b3bp?

- [Transloadit](https://transloadit.com)
- [OpenCoarrays](https://www.opencoarrays.org)
- [Sourcery Institute](https://www.sourceryinstitute.org)
- [Computational Brain Anatomy Laboratory](https://cobralab.ca/)
- [Genesis Cloud](https://genesiscloud.com/)

We are looking for endorsements! Are you also using b3bp? [Let us know](https://github.com/kvz/bash3boilerplate/issues/new?title=I%20use%20b3bp) and get listed.

## Authors

- [Kevin van Zonneveld](https://kvz.io)
- [Izaak Beekman](https://izaakbeekman.com/)
- [Manuel Streuhofer](https://github.com/mstreuhofer)
- [Alexander Rathai](mailto:Alexander.Rathai@gmail.com)
- [Dr. Damian Rouson](https://www.sourceryinstitute.org/) (documentation, feedback)
- [@jokajak](https://github.com/jokajak) (documentation)
- [Gabriel A. Devenyi](https://staticwave.ca/) (feedback)
- [@bravo-kernel](https://github.com/bravo-kernel) (feedback)
- [@skanga](https://github.com/skanga) (feedback)
- [galaktos](https://www.reddit.com/user/galaktos) (feedback)
- [@moviuro](https://github.com/moviuro) (feedback)
- [Giovanni Saponaro](https://github.com/gsaponaro) (feedback)
- [Germain Masse](https://github.com/gmasse)
- [A. G. Madi](https://github.com/warpengineer)
- [Lukas Stockner](mailto:oss@genesiscloud.com)
- [Gert Goet](https://github.com/eval)
- [@rfuehrer](https://github.com/rfuehrer)

## License

Copyright (c) 2013 Kevin van Zonneveld and [contributors](https://github.com/kvz/bash3boilerplate#authors).
Licensed under [MIT](https://raw.githubusercontent.com/kvz/bash3boilerplate/HEAD/LICENSE).
You are not obligated to bundle the LICENSE file with your b3bp projects as long
as you leave these references intact in the header comments of your source files.
