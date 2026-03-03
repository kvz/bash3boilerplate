#!/usr/bin/env bash
# Lint or fix shell scripts with shfmt.
#
# Usage:
#   test/shfmt.sh          # lint (exit 1 on diff)
#   test/shfmt.sh fix      # fix in place
#
# Installs shfmt idempotently if the expected version is not on PATH.

set -o errexit
set -o errtrace
set -o nounset
set -o pipefail

SHFMT_VERSION="${SHFMT_VERSION:-3.12.0}"
SHFMT_INSTALL_DIR="${SHFMT_INSTALL_DIR:-${HOME}/.local/bin}"

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__root="$(cd "$(dirname "${__dir}")" && pwd)"

### Ensure shfmt is available at the expected version
##############################################################################

__cleanup_webi_envman() {
  # Migrate away from old webi/envman-based installs.
  local marker='[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"'
  local comment='# Generated for envman. Do not edit.'
  local file=""
  local tmp=""
  local source_abs
  source_abs="${HOME}/.config/envman/load.sh"

  for file in "${HOME}/.bashrc" "${HOME}/.profile"; do
    if [[ ! -f "${file}" ]]; then
      continue
    fi

    if ! grep -Fq "${marker}" "${file}"; then
      continue
    fi

    tmp="$(mktemp)"
    awk -v marker="${marker}" -v comment="${comment}" '
      {
        if ($0 == marker || $0 == comment) {
          next
        }
        print
      }
    ' "${file}" >"${tmp}"
    mv "${tmp}" "${file}"
    echo "Removed envman shell hook from ${file}"
  done

  if [[ -d "${HOME}/.config/envman" ]]; then
    rm -rf "${HOME}/.config/envman"
    echo "Removed ${HOME}/.config/envman"
  fi

  if [[ -x "${HOME}/.local/bin/webi" || -L "${HOME}/.local/bin/webi" ]]; then
    rm -f "${HOME}/.local/bin/webi"
    echo "Removed ${HOME}/.local/bin/webi"
  fi

  if [[ -L "${HOME}/.local/bin/shfmt" ]]; then
    local linked
    linked="$(readlink -f "${HOME}/.local/bin/shfmt" || true)"
    if [[ "${linked}" == "${HOME}/.local/opt/shfmt-"*"/bin/shfmt" ]]; then
      rm -f "${HOME}/.local/bin/shfmt"
      rm -rf "$(dirname "$(dirname "${linked}")")"
      echo "Removed old webi-managed shfmt"
    fi
  fi

  if [[ -f "${source_abs}" ]]; then
    rm -f "${source_abs}"
  fi
}

__shfmt_ensure() {
  __cleanup_webi_envman

  if command -v shfmt >/dev/null 2>&1; then
    local current
    current="$(shfmt --version 2>/dev/null || true)"
    current="${current#v}"
    if [[ "${current}" = "${SHFMT_VERSION}" ]]; then
      return 0
    fi
    echo "shfmt ${current} found, need ${SHFMT_VERSION} — installing"
  fi

  local os arch
  os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  arch="$(uname -m)"

  case "${arch}" in
  x86_64) arch="amd64" ;;
  aarch64) arch="arm64" ;;
  arm64) arch="arm64" ;;
  *)
    echo "Unsupported architecture: ${arch}" >&2
    exit 1
    ;;
  esac

  local url="https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_${os}_${arch}"
  local target="${SHFMT_INSTALL_DIR}/shfmt"

  echo "Installing shfmt v${SHFMT_VERSION} (${os}/${arch}) to ${target}"
  mkdir -p "${SHFMT_INSTALL_DIR}"
  curl -fsSL "${url}" -o "${target}"
  chmod +x "${target}"

  # make sure it's on PATH for the rest of this script
  export PATH="${SHFMT_INSTALL_DIR}:${PATH}"
}

### Collect shell files
##############################################################################

__shfmt_files() {
  find "${__root}" -type f -name '*.sh' -not -path '*/node_modules/*'
}

### Main
##############################################################################

__shfmt_ensure

mode="${1:-lint}"

case "${mode}" in
fix)
  echo "Fixing with shfmt v${SHFMT_VERSION} (-i 2 -bn)"
  __shfmt_files | xargs shfmt -w -i 2 -bn
  echo "Done"
  ;;
lint)
  echo "Linting with shfmt v${SHFMT_VERSION} (-i 2 -bn)"
  if ! __shfmt_files | xargs shfmt -d -i 2 -bn; then
    echo ""
    echo "Formatting issues found. Run 'yarn fix:shfmt' to fix."
    exit 1
  fi
  echo "OK"
  ;;
*)
  echo "Usage: ${0} [lint|fix]" >&2
  exit 1
  ;;
esac
