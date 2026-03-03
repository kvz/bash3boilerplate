# Contributing to BASH3 Boilerplate

Please fork this repository, create a branch containing your suggested changes, and submit a pull request based on the `main` branch of <https://github.com/kvz/bash3boilerplate/>.

## Testing

Run the regular test suite:

```bash
yarn test
```

Run a fast contract-focused subset:

```bash
yarn test:fast
```

Run the Bash 3.2.57 compatibility suite in Docker:

```bash
yarn test:bash3:docker
```

Run all checks used for release confidence:

```bash
yarn test:all
```

CI runs on Linux (`ubuntu-latest`), macOS (`macos-latest`, Bash 3.2), and a Docker Bash 3.2.57 lane. The native and Docker lanes are complementary and catch different classes of portability issues.

## Coding standards

These rules are CI-enforced for contributions to b3bp itself:

1. Use two spaces for indentation; do not use tab characters.
1. Do not introduce trailing whitespace on lines.
1. Use a single equal sign when checking `if [[ "${NAME}" = "Kevin" ]]`.
1. Use the bash test operator (`[[ ... ]]`) rather than `[` or `test`.
1. Use braces around variable expansions: `${VAR}`.
1. Keep ShellCheck clean at `warning` severity or above.

## Releasing

Before running a release command (`yarn release:patch`, `yarn release:minor`, `yarn release:major`):

1. Ensure you are on `main` with a clean working tree.
1. Ensure CI checks for `HEAD` on `main` are green.
1. Update `CHANGELOG.md` `## main` section with completed checklist entries (`- [x]`) and no remaining open checklist items (`- [ ]`).

Automated gate:

```bash
yarn release:ready
```

The `release` script runs this gate automatically before tagging/publishing.
