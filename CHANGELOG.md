# Changelog

Please see the [CHANGELOG.md](./CHANGELOG.md) file.

## master (Unreleased)

- Make license more permissive by not requiring distribution of the LICENSE file if the copyright & attribution comments are left intact
- Respect `--no-color` by setting the NO_COLOR flag in `main.sh` (#25, thx @gdevenyi)
- Split out changelog into separate file
- Added a [FAQ](./FAQ.md) (#15, #14, thanks @rouson)
- Fix Travis OSX testing (before, it would silently pass failures) (#10)
- Enable dashes in long, GNU style options, as well as numbers (thanks @zbeekman)

## v2.0.0 (2016-02-17)

- Add tests for `templater` and follow Library export best practices
- Add tests for `ini_val` and follow Library export best practices
- Add tests for `parse_url` and follow Library export best practices
- Add tests for `megamount` and follow Library export best practices
- Remove `bump` from `src` (BREAKING)
- Remove `semver` from `src` (BREAKING)

## v1.2.1 (2016-02-17)

- Add Travis CI automated testing for OSX (thanks @zbeekman)

## v1.2.0 (2016-02-16)

- Allow disabling colors via `NO_COLOR` environment variable
- Enable `errexit`, `nounset` and `pipefail` options at the top of the script already
- More refined colors (thanks @arathai)
- Add a changelog to the README
- Add `__os` magic var (limited to discovering OSX and defaulting to Linux for now)
- Add `__base` magic var (`main`, if the source script is `main.sh`)
- Enable long, GNU style options (thanks @zbeekman)
- Add Travis CI automated testing for Linux

## v1.1.0 (2015-06-29)

- Add `ALLOW_REMAINDERS` configuration to templater
- Fix typo: 'debugmdoe' to 'debugmode' (thanks @jokajak)
- Use `${BASH_SOURCE[0]}` for `__file` instead of `${0}`

## v1.0.3 (2014-11-02)

- Add `ini_val`, `megamount`, `parse_url`
- Add re-usable libraries in `./src`
- Use npm as an additional distribution channel
