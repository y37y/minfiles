#!/usr/bin/env bash
set -euo pipefail

# minfiles setup: minimal profile
# Installs ONLY: ~/.bashrc and ~/.vimrc
# Default: symlink from repo -> home
# Copy mode: COPY=1 ./minimal.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROFILE_DIR="${REPO_ROOT}/profiles/minimal"

COPY_MODE="${COPY:-0}"              # COPY=1 to copy instead of symlink
HOME_DIR="${HOME_DIR:-$HOME}"       # can override: HOME_DIR=/root ./minimal.sh

say()  { printf '%s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

need_file() {
  [[ -f "$1" ]] || die "Missing required file: $1"
}

backup_if_exists() {
  local dst="$1"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    local ts
    ts="$(date +%Y%m%d-%H%M%S)"
    mv "$dst" "${dst}.bak.${ts}"
    warn "Backed up existing $(basename "$dst") -> $(basename "$dst").bak.${ts}"
  elif [[ -L "$dst" ]]; then
    warn "Replacing existing symlink: $dst"
    rm -f "$dst"
  fi
}

install_one() {
  local src="$1" dst="$2"
  need_file "$src"
  backup_if_exists "$dst"

  if [[ "$COPY_MODE" == "1" ]]; then
    cp -f "$src" "$dst"
    say "Copied:  $dst"
  else
    # -s symlink, -f replace, -n treat link as file
    ln -sfn "$src" "$dst"
    say "Linked:  $dst -> $src"
  fi
}

ensure_vim_dirs() {
  mkdir -p "${HOME_DIR}/.vim/swap" "${HOME_DIR}/.vim/undo"
  chmod 700 "${HOME_DIR}/.vim/swap" "${HOME_DIR}/.vim/undo" || true
}

main() {
  say "== minfiles: minimal profile =="
  say "Repo:   $REPO_ROOT"
  say "Home:   $HOME_DIR"
  say "Mode:   $([[ "$COPY_MODE" == "1" ]] && echo copy || echo symlink)"
  say ""

  ensure_vim_dirs

  install_one "${PROFILE_DIR}/.bashrc" "${HOME_DIR}/.bashrc"
  install_one "${PROFILE_DIR}/.vimrc"  "${HOME_DIR}/.vimrc"

  say ""
  say "Done."
  say "Tip: start a new shell or run: source ~/.bashrc"
}

main "$@"
