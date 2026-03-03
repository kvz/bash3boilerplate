# b3bp Design Principles

## Purpose

This document defines how b3bp scripts are intended to be authored and maintained so that guidance, code, and CI stay consistent.

## Script Archetypes

### 1) Entrypoint scripts

Examples: `main.sh`, app-facing CLI scripts.

- Own process lifecycle and argument parsing.
- Enable strict options at top-level.
- May `exit` directly.
- Should not be sourced for reuse.

### 2) Library scripts

Examples: reusable functions in `src/*.sh`.

- Safe to `source`.
- No top-level side effects beyond defining functions.
- Use function-scoped strict mode so parent shell options are not mutated.
- Functions should communicate failure via return status (or non-zero command exits inside function scope).

## Function Packaging

For reusable functions, support both source and execute modes:

```bash
my_fn() (
  set -o errexit
  set -o errtrace
  set -o nounset
  set -o pipefail

  # function body
)

if [[ "${BASH_SOURCE[0]:-}" != "${0}" ]]; then
  export -f my_fn
else
  my_fn "$@"
  exit
fi
```

Notes:

- Use `[[ ... ]]` in Bash code.
- Prefer `"$@"` over `"${@}"`.
- `export -f` is optional. Use it only when child Bash processes must inherit the function.

## Error-Handling Contract

- `Entrypoint`: may `exit` and print user-facing errors.
- `Library`: avoid global shell-option mutation and keep failure semantics local to function execution.
- If a library function must mutate caller state, do not use a subshell-style function body; use an explicit save/restore options wrapper.

## Parser Contract

Argument parser behavior is part of the public contract and must be covered by tests:

- unknown options fail with clear errors
- missing required option values fail fast
- long-option formats (`--opt value` and `--opt=value`) behave consistently

## Portability Boundaries

b3bp targets Bash 3+ portability, not shell-agnostic portability.

- In scope: Bash 3 behavior and Bash syntax.
- Out of scope: `dash`, `zsh`, `ksh`, `posh`, etc.
- Tooling portability (GNU vs BSD/BusyBox utilities) is separate and must be validated through CI coverage.

## Test Matrix Expectations

Keep both lanes:

- Native macOS lane for real Bash 3.2 + macOS tool behavior.
- Linux Docker lane pinned to Bash 3.2.57 for reproducible local/CI checks.

## Documentation Rules

- Prefer stable links (e.g., `HEAD`) over brittle historical line links where possible.
- Keep README/FAQ aligned with this document.
- If behavior changes, update tests first, then docs, then examples.
