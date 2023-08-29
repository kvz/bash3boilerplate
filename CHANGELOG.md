# Changelog

Here's is a combined todo/done list. You can see what todos are planned for the upcoming release, as well as ideas that may/may not make into a release in `Ideas`.

## Ideas

Unplanned.

- [ ] Better style guide checking (#84)

## main

Released: TBA.
[Diff](https://github.com/kvz/bash3boilerplate/compare/2.7.2...main).

- [ ]

## 2.7.2

Released: 2023-08-29
[Diff](https://github.com/kvz/bash3boilerplate/compare/v2.4.1...2.7.2).

- [x] Upgrade and cleanup node dependencies
- [x] Remove lanyon-based website in favor of simple redirect to github for bash3boilerplate.sh
- [x] Make tests pass again
- [x] Make linting and style checking separate actions
- [x] Add feature to edit/update comments in ini file (#132, @rfuehrer)
- [x] Upgrade to `lanyon@0.1.16`
- [x] Capture correct error_code in err_report (#124, @eval)
- [x] Enhanced ini file handling: create new file, create new sections, handle default section, read key from given section (@rfuehrer)

## v2.4.2

Released: 2019-11-07.
[Diff](https://github.com/kvz/bash3boilerplate/compare/v2.4.1...v2.4.2).

- [x] Upgrade to `lanyon@0.1.16`
- [x] Capture correct error_code in err_report (#124, @eval)
- [x] Enhanced ini file handling: create new file, create new sections, handle default section, read key from given section (@rfuehrer)

## v2.4.1

Released: 2019-11-07.
[Diff](https://github.com/kvz/bash3boilerplate/compare/v2.3.0...v2.4.1).

- [x] Upgrade to `lanyon@0.1.7`
- [x] Allow counting how many times an argument is used (@genesiscloud)
- [x] Fix typos in megamount (thanks @gsaponaro)
- [x] Enable color in screen or tmux (#92, @gmasse)
- [x] Change `egrep` to `grep -E` in test and lib scripts to comply with ShellCheck (#92, @gmasse)
- [x] Fix typo in FAQ (#92, @gmasse)
- [x] Fix Travis CI failure on src/templater.sh (@gmasse)
- [x] Add magic variable which contains full command invocation
- [x] More contrasted alert and emergency colors (#111 @gmeral)
- [x] Add support for repeatable arguments (@genesiscloud)
- [x] Fix remaining warnings with shellcheck v0.7.0 (#107, @genesiscloud)

## v2.4.0

Released: 2016-12-21.
[Diff](https://github.com/kvz/bash3boilerplate/compare/v2.3.0...v2.4.0).

- [x] Upgrade to `lanyon@0.0.143`

## v2.3.0

Released: 2016-12-21.
[Diff](https://github.com/kvz/bash3boilerplate/compare/v2.2.0...v2.3.0).

- [x] Add magic variable `__i_am_main_script` to distinguish if b3bp is being sourced or called directly (#45, @zbeekman)
- [x] Add style checks for tab characters and trailing whitespace (@zbeekman)
- [x] Add backtracing to help localize errors (#44, @zbeekman)
- [x] Additional FAQ entries (#47, suggested by @gdevenyi, implemented by @zbeekman)
- [x] Ensure that shifting over `--` doesn't throw an errexit error (#21, @zbeekman)
- [x] Add Pull Request template (#83)

## v2.2.0

Released: 2016-12-21.
[Diff](https://github.com/kvz/bash3boilerplate/compare/v2.1.0...v2.2.0).

- [x] README and FAQ improvements (#66, @mstreuhofer)
- [x] Add support for sourcing b3bp (#61, @mstreuhofer)
- [x] Upgrade all Node.js dependencies for development (#78)
- [x] Switch to http://lanyon.io for static site building, add a new logo
- [x] Cleanup environment variables (#58, @mstreuhofer)
- [x] Support multi-line logs (#57, @mstreuhofer)
- [x] Run shellcheck as part of the acceptance test (#79, @mstreuhofer)
- [x] Brace all variables, used `[[` instead of `[` (#33, #76, @mstreuhofer)
- [x] Add automatic usage validation for required args (#22, #65, @mstreuhofer)
- [x] Remove all usage of eval (@mstreuhofer)
- [x] Get rid of awk, sed & egrep usage (#71, @mstreuhofer)
- [x] Fix auto-color-off code (#69, #70, @mstreuhofer)
- [x] Use shellcheck to find and fix unclean code (#68, #80, @mstreuhofer)
- [x] Allow for multiline opt description in `__usage` (#7, @mstreuhofer)
- [x] Allow `__usage` and `__helptext` to be defined before sourcing `main.sh` thus makeing b3bp behave like a library (@mstreuhofer)
- [x] Add the same License text to each script header (@mstreuhofer)

## v2.1.0

Released: 2016-11-08.
[Diff](https://github.com/kvz/bash3boilerplate/compare/v2.0.0...v2.1.0).

- [x] Cleanup b3bp variables (adds prefixes across the board) (thanks @mstreuhofer)
- [x] Add multi-line logging support (thanks @mstreuhofer)
- [x] Mangle long-option names to allow dashes (thanks @zbeekman)
- [x] Remove OS detection altogether (#38, thx @zbeekman)
- [x] Offer the main template for download as http://bash3boilerplate.sh/main.sh
- [x] Better OS detection (#38, thx @moviuro)
- [x] Improve README copy (#34, thx galaktos)
- [x] Fix unquoted variable access within (#34 thx galaktos)
- [x] For delete-key-friendliness, bundle the commandline definition block along with its parser
- [x] Less verbose header comments
- [x] For delete-key-friendliness, don't crash on undeclared help vars
- [x] Introduce `errtrace`, which is on by default (BREAKING)
- [x] Add a configurable `helptext` that is left alone by the parses and allows you to have a richer help
- [x] Add a simple documentation website
- [x] Add best practice of using `__double_underscore_prefixed_vars` to indicate global variables that are solely controlled inside your script
- [x] Make license more permissive by not requiring distribution of the LICENSE file if the copyright & attribution comments are left intact
- [x] Respect `--no-color` by setting the `NO_COLOR` flag in `main.sh` (#25, thx @gdevenyi)
- [x] Split out changelog into separate file
- [x] Added a [FAQ](./FAQ.md) (#15, #14, thanks @rouson)
- [x] Fix Travis OSX testing (before, it would silently pass failures) (#10)
- [x] Enable dashes in long, GNU style options, as well as numbers (thanks @zbeekman)

## v2.0.0

Released: 2016-02-17.
[Diff](https://github.com/kvz/bash3boilerplate/compare/v1.2.1...v2.0.0).

- [x] Add tests for `templater` and follow Library export best practices
- [x] Add tests for `ini_val` and follow Library export best practices
- [x] Add tests for `parse_url` and follow Library export best practices
- [x] Add tests for `megamount` and follow Library export best practices
- [x] Remove `bump` from `src` (BREAKING)
- [x] Remove `semver` from `src` (BREAKING)

## v1.2.1

Released: 2016-02-17.
[Diff](https://github.com/kvz/bash3boilerplate/compare/v1.2.0...v1.2.1).

- [x] Add Travis CI automated testing for OSX (thanks @zbeekman)

## v1.2.0

Released: 2016-02-16.
[Diff](https://github.com/kvz/bash3boilerplate/compare/v1.1.0...v1.2.0).

- [x] Allow disabling colors via `NO_COLOR` environment variable
- [x] Enable `errexit`, `nounset` and `pipefail` options at the top of the script already
- [x] More refined colors (thanks @arathai)
- [x] Add a changelog to the README
- [x] Add `__os` magic var (limited to discovering OSX and defaulting to Linux for now)
- [x] Add `__base` magic var (`main`, if the source script is `main.sh`)
- [x] Enable long, GNU style options (thanks @zbeekman)
- [x] Add Travis CI automated testing for Linux

## v1.1.0

Released: 2015-06-29.
[Diff](https://github.com/kvz/bash3boilerplate/compare/v1.0.3...v1.1.0).

- [x] Add `ALLOW_REMAINDERS` configuration to templater
- [x] Fix typo: 'debugmdoe' to 'debugmode' (thanks @jokajak)
- [x] Use `${BASH_SOURCE[0]}` for `__file` instead of `${0}`

## v1.0.3

Released: 2014-11-02.
[Diff](https://github.com/kvz/bash3boilerplate/compare/5db569125319a89b9561b434db84e4d91faefb63...v1.0.3).

- [x] Add `ini_val`, `megamount`, `parse_url`
- [x] Add re-usable libraries in `./src`
- [x] Use npm as an additional distribution channel
