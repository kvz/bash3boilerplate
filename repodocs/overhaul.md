# Overhaul Plan Log

## Format
- This file is append-only.
- Every new update must use a new section header in the form `## Iteration ${index}`.
- Content inside each `## Iteration ${index}` section must contain bullet points only.
- Each iteration should include plan bullets first, then progress bullets, then key learning bullets.

## Iteration 1
- Date: 2026-03-03.
- Plan: Fix long-option parsing correctness in `main.sh`, starting with unknown long options and missing-value handling.
- Plan: Make `src/parse_url.sh` safe under strict mode (`set -euo pipefail`) for URLs without optional parts.
- Plan: Add/expand acceptance scenarios that lock parser and strict-mode behavior.
- Plan: Add CI coverage that actually runs Bash 3.2 and modern Bash.
- Plan: Fix lint/style reliability so checks run on all shell files and are consistent locally and in CI.
- Plan: Refresh stale docs and examples (old CI links, old version references, and outdated pointers).
- Plan: De-risk release automation (remove forced tag push and enforce green checks before publishing).
- Progress: Completed direct maintainer audit across `main.sh`, `src/*.sh`, tests, CI, and docs.
- Progress: Reproduced parser bug where `--file --debug` sets `arg_f=--debug` and leaves `arg_d=0`.
- Progress: Reproduced parser bug where unknown long options are not rejected early and lead to misleading validation errors.
- Progress: Reproduced strict-mode failure in `parse_url` for standard URLs without `@` userinfo.
- Progress: Verified acceptance tests pass today, which confirms coverage gaps for the failing edge cases.
- Key learning: The parser currently assumes that any long option with an argument can consume the next token even when it is another option.
- Key learning: Bash 3 portability is a stated goal, but CI currently validates only one Linux Bash runtime.
- Key learning: Tooling trust is reduced because style linting currently processes only one file despite repository-wide intent.

## Iteration 2
- Date: 2026-03-03.
- Plan: Fix long-option parsing behavior in `main.sh` for unknown options and missing values.
- Plan: Refactor `src/parse_url.sh` to avoid strict-mode failures from `grep`-based parsing.
- Plan: Add acceptance scenarios for parser edge cases and strict-mode parse_url execution.
- Plan: Fix style checker so `lint:style` validates all discovered shell files.
- Plan: Expand CI to include macOS (Bash 3.2) alongside Ubuntu.
- Plan: Remove forced tag push from release script to reduce release risk.

## Iteration 3
- Date: 2026-03-03.
- Progress: Updated `main.sh` long-option handling to reject unknown long options immediately.
- Progress: Updated `main.sh` long-option handling to fail fast on missing required values instead of consuming the next option token.
- Progress: Updated `main.sh` long-option handling to reject `--flag=value` for flags that do not accept values.
- Progress: Refactored `src/parse_url.sh` to pure Bash parameter parsing, removing `grep`-based command substitutions that fail in strict mode.
- Progress: Added `test/scenario/main-longopt-errors/run.sh` and matching fixtures to lock parser edge-case behavior.
- Progress: Added `test/scenario/parse_url-strict/run.sh` and matching fixtures to lock strict-mode `parse_url` behavior.
- Progress: Fixed `test/style.pl` to process all provided file arguments instead of only the first file.
- Progress: Updated lint scripts in `package.json` to scan all shell files while excluding `node_modules`.
- Progress: Updated CI workflow to run on both `ubuntu-latest` and `macos-13`, with macOS dependencies for acceptance tests.
- Progress: Updated release automation in `package.json` to remove forced tag push.
- Progress: Refreshed stale references in script headers and `FAQ.md` (old links, stale versions, broken anchor, retired Travis references).
- Validation: `SHELLCHECK_SEVERITY=warning yarn lint:shellcheck` passes.
- Validation: `yarn lint:style` passes.
- Validation: `yarn test` passes with all scenarios including newly added ones.
- Key learning: Parser correctness needed explicit argument-token validation for long options to avoid ambiguous consumption.
- Key learning: Strict mode (`set -e`) can make command-substitution pipelines fragile in utility functions even when behavior appears correct in non-strict shells.
- Key learning: The previous lint pipeline created false confidence by scanning only shallow paths and style-checking a single file.

## Iteration 4
- Date: 2026-03-03.
- Plan: Get draft PR CI to green status.
- Progress: Opened draft PR #172 from `maintainer/overhaul-pass-1`.
- Progress: Identified CI failure root cause from check annotations: runner config `macos-13-us-default` is unsupported in this environment.
- Progress: Updated workflow matrix macOS label from `macos-13` to `macos-latest`.
- Key learning: Runner-label support is environment-specific; use CI annotations to validate labels before assuming availability.
