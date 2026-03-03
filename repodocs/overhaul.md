# Overhaul Summary

Branch `maintainer/overhaul-pass-1` (PR #172) addressed:

1. **Parser correctness** — Long-option handling now rejects unknown options, fails fast on missing values, rejects `--flag=value` for flags, and respects `--` separator.
2. **Strict-mode safety** — All `src/*.sh` libraries use function-scoped strict mode via subshell execution `()`, preventing caller shell option mutation.
3. **`parse_url` rewrite** — Replaced `grep`-based command substitutions with pure Bash parameter expansion, eliminating strict-mode failures.
4. **CI expansion** — Added macOS lane and Docker Bash 3.2.57 lane alongside existing Ubuntu coverage.
5. **Test coverage** — Added contract scenarios for parser edge cases, library robustness, and logging behavior.
6. **Release governance** — Added `release-ready` gate enforcing branch, CI status, and changelog quality. Release script defers tag creation until after commit.
7. **Lint expansion** — Style checker now processes all shell files. ShellCheck runs at warning severity in CI.
8. **Documentation** — Design principles, FAQ updates, stale reference cleanup, function packaging examples updated to current patterns.

Detailed iteration history is preserved in git log.
