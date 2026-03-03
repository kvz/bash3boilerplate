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

## Iteration 5
- Date: 2026-03-03.
- Plan: Confirm final draft PR health and CI result.
- Progress: Verified draft PR #172 is open and up to date with branch head `9d243a7`.
- Progress: Verified CI run `22615452357` completed successfully on both `ci (ubuntu-latest)` and `ci (macos-latest)`.
- Key learning: `gh pr checks --watch` gives a reliable end-to-end view once check runs have been registered for the latest commit.

## Iteration 6
- Date: 2026-03-03.
- Plan: Add a Dockerized Bash 3.2.57 test lane runnable locally and in CI.
- Plan: Keep native macOS CI coverage and use Docker lane as Linux-reproducible complement.
- Plan: Add documented local commands for running Bash 3 tests in Docker.
- Plan: Wire CI to execute the Docker Bash 3 lane on pull requests.

## Iteration 7
- Date: 2026-03-03.
- Progress: Verified `bash:3.2.57` image availability and confirmed runtime `GNU bash, version 3.2.57(1)-release`.
- Progress: Added `test/bash3-docker.sh` to run acceptance tests inside Docker with Bash 3.2.57.
- Progress: Added `test:bash3:docker` npm script for local maintainers.
- Progress: Added `ci-bash3-docker` GitHub Actions job to run Docker Bash 3 tests on pull requests.
- Progress: Fixed Alpine tool incompatibilities by installing GNU `coreutils` and `diffutils` in the Docker test environment.
- Progress: Added README testing instructions for regular and Docker Bash 3 test lanes.
- Validation: `yarn test:bash3:docker` passes locally.
- Validation: `SHELLCHECK_SEVERITY=warning yarn lint:shellcheck` passes locally.
- Validation: `yarn lint:style` passes locally.
- Validation: `yarn test` passes locally.
- Key learning: The official `bash:3.2.57` image is Alpine-based, so BusyBox tool behavior differs from GNU utilities used by the acceptance harness.
- Key learning: A Docker Bash 3 lane is practical and reproducible, but native macOS CI still remains necessary for macOS-specific behavior.

## Iteration 8
- Date: 2026-03-03.
- Plan: Apply consistent function-packaging pattern across reusable `src/*.sh` scripts.
- Plan: Keep strict shell options scoped to function execution so sourced scripts do not mutate caller shell options.
- Plan: Use defensive sourced-vs-executed guard (`${BASH_SOURCE[0]:-}`), `[[ ... ]]`, and simplify `exit $?` to `exit`.
- Plan: Re-run lint and acceptance tests (including Docker Bash 3 lane) after refactor.

## Iteration 9
- Date: 2026-03-03.
- Progress: Updated `src/templater.sh` to run strict mode (`errexit`, `errtrace`, `nounset`, `pipefail`) inside function scope via subshell execution.
- Progress: Updated `src/parse_url.sh` to run strict mode inside function scope and switched positional read to `${1:-}` for defensive invocation.
- Progress: Updated `src/ini_val.sh` to run strict mode inside function scope and declared missing locals (`current_comment`, `RET`).
- Progress: Updated `src/megamount.sh` to run strict mode inside function scope and use defensive argument reads (`${1:-}`, `${2:-}`).
- Progress: Standardized source-vs-exec guards to `[[ "${BASH_SOURCE[0]:-}" != "${0}" ]]` across all reusable `src/*.sh` scripts.
- Progress: Simplified direct-execution epilogues from `exit $?` to `exit` after function invocation.
- Validation: `SHELLCHECK_SEVERITY=warning yarn lint:shellcheck` passes.
- Validation: `yarn lint:style` passes.
- Validation: `yarn test` passes.
- Validation: `yarn test:bash3:docker` passes.
- Key learning: Function-scoped strict mode gives consistent behavior whether functions are called from sourced scripts or direct execution, while protecting caller shell option state.
- Key learning: Subshell-scoped function execution is safe for these utilities because they do not need to mutate caller variables.

## Iteration 10
- Date: 2026-03-03.
- Plan: Add `repodocs/design-principles.md` to formalize b3bp’s operating model.
- Plan: Define explicit script archetypes (`entrypoint` vs `library`) and map strict-mode expectations to each.
- Plan: Clarify policy for `exit` vs `return`, `export -f`, parser contract ownership, and portability boundaries.
- Plan: Align `README.md` and `FAQ.md` so user-facing guidance points to the same principles.

## Iteration 11
- Date: 2026-03-03.
- Progress: Added `repodocs/design-principles.md` as the canonical reference for script archetypes, strict-mode scope, parser contract, portability boundaries, and documentation rules.
- Progress: Updated `README.md` to include a new `Design Principles` section and linked guidance.
- Progress: Updated `README.md` function-packaging example to use function-scoped strict mode and defensive source-vs-exec guard.
- Progress: Updated `FAQ.md` with new entries for `entrypoint vs library` and `when to use export -f`.
- Progress: Updated `FAQ.md` CI wording to match current runner naming (`macos-latest`).
- Validation: `SHELLCHECK_SEVERITY=warning yarn lint:shellcheck` passes.
- Validation: `yarn test` passes.
- Key learning: Formalizing archetypes in one canonical document reduces contradictory guidance across README, FAQ, and code examples.

## Iteration 12
- Date: 2026-03-03.
- Plan: Condense design principles and fold them directly into `README.md`.
- Plan: Remove duplicate principles doc from `repodocs/` to avoid maintenance drift.
- Plan: Add a concrete two-week next-level execution roadmap to `README.md`.
- Plan: Repoint FAQ references to the README principles section.
- Plan: Re-run lint and tests to validate documentation edits do not break existing checks.

## Iteration 13
- Date: 2026-03-03.
- Progress: Folded the design principles content directly into the `README.md` `Design Principles` section.
- Progress: Added a concrete `Next-Level Roadmap` section to `README.md` with week-by-week execution steps.
- Progress: Updated `FAQ.md` to reference `README.md#design-principles` instead of a separate design-principles file.
- Progress: Removed `repodocs/design-principles.md` to eliminate duplicate-document drift.
- Validation: `SHELLCHECK_SEVERITY=warning yarn lint:shellcheck` passes.
- Validation: `yarn test` passes.
- Key learning: A single canonical principles location in README reduces inconsistency and lowers documentation maintenance overhead.

## Iteration 14
- Date: 2026-03-03.
- Progress: Investigated failing `ci-bash3-docker` run on PR head `1e53e28`; root cause was `pipefail` + `bash --version | head -n 1` causing SIGPIPE exit code `141`.
- Progress: Updated `test/bash3-docker.sh` to avoid the pipe and print `bash --version` directly.
- Validation: `yarn test:bash3:docker` passes.
- Validation: `SHELLCHECK_SEVERITY=warning yarn lint:shellcheck` passes.
- Validation: `yarn test` passes.
- Key learning: Under `pipefail`, convenience pipes in diagnostics can become hard failures in CI even if they look harmless locally.

## Iteration 15
- Date: 2026-03-03.
- Plan: Start roadmap Week 1 by adding a lightweight parser/logging behavior spec and mapping existing scenarios to explicit contracts.
- Plan: Add parser edge-case coverage for `--` separator behavior and invalid long-option assignment to flags.
- Plan: Add contributor-friendly fast/all test commands through npm scripts (`test:fast`, `test:all`).
- Plan: Validate with lint, normal tests, and Docker Bash 3 tests.

## Iteration 16
- Date: 2026-03-03.
- Progress: Extended `test/scenario/main-longopt-errors/run.sh` with two new parser contract cases: `flag-assignment-on-boolean` and `double-dash-separator`.
- Progress: Updated `test/fixture/main-longopt-errors.stdio` with deterministic datetime replacement marker and new expected outputs.
- Progress: Added npm scripts `test:fast` and `test:all` in `package.json` for contributor ergonomics and release-confidence runs.
- Progress: Added `Behavior Contracts` section to `README.md`, including parser/logging contracts and scenario mapping.
- Validation: `yarn test:fast` passes.
- Validation: `SHELLCHECK_SEVERITY=warning yarn lint:shellcheck` passes.
- Validation: `yarn lint:style` passes.
- Validation: `yarn test` passes.
- Validation: `yarn test:bash3:docker` passes.
- Key learning: Explicit contract mapping in README improves discoverability of why each scenario exists and which behavior it protects.

## Iteration 17
- Date: 2026-03-03.
- Plan: Add focused library robustness scenarios for `parse_url`, `ini_val`, and `templater`.
- Plan: Cover boundary inputs (missing optional URL parts, default section behavior, special-character templating values, and expected failure modes).
- Plan: Update README contract mapping to include library robustness contracts and their scenario coverage.
- Plan: Validate with lint, full acceptance, and Docker Bash 3 lane.

## Iteration 18
- Date: 2026-03-03.
- Progress: Added `test/scenario/parse_url-robust/run.sh` and fixtures to cover missing protocol, default ports, user-without-pass, and explicit-port/no-path behavior.
- Progress: Added `test/scenario/ini_val-robust/run.sh` and fixtures to cover default-section keys, comment-preserving key updates, and sourced usage reads/writes.
- Progress: Added `test/scenario/templater-robust/run.sh` and fixtures to cover special-character replacement values, sourced invocation, and missing-template failure handling.
- Progress: Expanded `test:fast` in `package.json` to include new robustness scenarios.
- Progress: Updated README `Behavior Contracts` section with a `Library robustness contracts` subsection and scenario mapping.
- Validation: `yarn test:fast` passes.
- Validation: `SHELLCHECK_SEVERITY=warning yarn lint:shellcheck` passes.
- Validation: `yarn lint:style` passes.
- Validation: `yarn test` passes.
- Validation: `yarn test:bash3:docker` passes.
- Key learning: Adding targeted edge-case scenarios around reusable libraries improves confidence without needing to make full acceptance fixtures more brittle.

## Iteration 19
- Date: 2026-03-03.
- Plan: Implement Week 2 release governance by adding a release-ready gate that checks branch cleanliness, CI status on HEAD, and changelog quality in `## main`.
- Plan: Add a README release checklist section that mirrors and explains the release-ready gate.
- Plan: Add a README migration guide section that maps older packaging/style patterns to current recommended patterns.
- Plan: Trim style guidance so the explicitly required rules are CI-enforced, and label remaining items as recommendations.
- Plan: Replace brittle FAQ line links with stable behavior-oriented references.

## Iteration 20
- Date: 2026-03-03.
- Progress: Added `test/release-ready.sh` to gate releases on branch cleanliness, `main` branch requirement, GitHub check success for HEAD, and `CHANGELOG.md` `## main` checklist quality.
- Progress: Wired `yarn release:ready` into `package.json` and made `release` depend on it.
- Progress: Added `Release Checklist` section to README and documented the automated release gate command.
- Progress: Added `Migration Guide` section to README with old-to-new patterns for strict mode scope, source/execute guard, and CI-enforced style rules.
- Progress: Trimmed README style language so explicitly required rules are CI-enforced and clearly labeled.
- Progress: Replaced brittle FAQ line-number links with behavior-based stable references.
- Validation: `yarn release:ready` fails correctly on non-`main` branch with an explicit message.
- Validation: `SHELLCHECK_SEVERITY=warning yarn lint:shellcheck` passes.
- Validation: `yarn lint:style` passes.
- Validation: `yarn test` passes.
- Validation: `yarn test:bash3:docker` passes.
- Key learning: Converting release assumptions into an executable gate catches process issues earlier and makes release criteria auditable.

## Iteration 21
- Date: 2026-03-03.
- Plan: Add an automated docs-lint check for brittle historical references (legacy Travis links and version-pinned GitHub line links).
- Plan: Wire docs-lint into the existing `yarn lint` pipeline so documentation guidance is enforceable.
- Plan: Validate the new lint check alongside existing shell/test lanes.

## Iteration 22
- Date: 2026-03-03.
- Progress: Added `test/docs-lint.sh` to detect legacy Travis links and brittle GitHub line-number links in `README.md` and `FAQ.md`.
- Progress: Added `lint:docs` to `package.json` and integrated it into `yarn lint` via existing `lint:**` script expansion.
- Validation: `yarn lint:docs` passes.
- Validation: `SHELLCHECK_SEVERITY=warning yarn lint:shellcheck` passes.
- Validation: `yarn lint:style` passes.
- Validation: `yarn test` passes.
- Validation: `yarn test:bash3:docker` passes.
- Key learning: Treating docs hygiene as a CI gate prevents stale references from quietly returning over time.
