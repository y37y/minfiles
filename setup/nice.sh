#!/usr/bin/env bash
set -eo pipefail

# minfiles setup: nice profile
# Installs ONLY: ~/.bashrc and ~/.vimrc
# Default: symlink from repo -> home
# Copy mode: COPY=1 ./nice.sh
#
# Vim plugins:
# - PLUGINS=1 : force install
# - PLUGINS=0 : skip
# - unset:
#     * TTY        -> prompt (default YES)
#     * non-TTY    -> install by default

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
PROFILE_DIR="${REPO_ROOT}/profiles/nice"

COPY_MODE="${COPY:-0}"               # COPY=1 to copy instead of symlink
HOME_DIR="${HOME_DIR:-$HOME}"
VIM_PACK_DIR="${HOME_DIR}/.vim/pack/minfiles/start"
PLUGINS="${PLUGINS:-}"

say()  { printf '%s\n' "$*"; }
warn() { printf 'WARN: %s\n' "$*" >&2; }
die()  { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

have() { command -v "$1" >/dev/null 2>&1; }

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
    ln -sfn "$src" "$dst"
    say "Linked:  $dst -> $src"
  fi
}

git_clone_or_update() {
  local name="$1" url="$2" dir="${VIM_PACK_DIR}/${name}"

  if [[ -d "$dir/.git" ]]; then
    say "Updating plugin: $name"
    git -C "$dir" pull --ff-only
  else
    say "Installing plugin: $name"
    git clone --depth 1 "$url" "$dir"
  fi
}

prompt_yes_no() {
  local prompt="$1" default="$2" reply

  if [[ ! -t 0 ]]; then
    # non-TTY → accept default
    [[ "$default" == "y" ]]
    return
  fi

  while true; do
    read -r -p "${prompt} [y/n] (default: ${default}) " reply || true
    reply="${reply:-$default}"
    case "$reply" in
      y|Y) return 0 ;;
      n|N) return 1 ;;
    esac
  done
}

ensure_vim_dirs() {
  mkdir -p "${HOME_DIR}/.vim/swap" "${HOME_DIR}/.vim/undo"
  chmod 700 "${HOME_DIR}/.vim/swap" "${HOME_DIR}/.vim/undo" || true
}

install_vim_plugins() {
  have git || die "git is required to install plugins"
  mkdir -p "$VIM_PACK_DIR"

  git_clone_or_update "tokyonight"     "https://github.com/ghifarit53/tokyonight-vim.git"
  git_clone_or_update "vim-fugitive"   "https://github.com/tpope/vim-fugitive.git"
  git_clone_or_update "vim-airline"    "https://github.com/vim-airline/vim-airline.git"
  git_clone_or_update "airline-themes" "https://github.com/vim-airline/vim-airline-themes.git"
  git_clone_or_update "auto-pairs"     "https://github.com/jiangmiao/auto-pairs.git"
  git_clone_or_update "fzf.vim"        "https://github.com/junegunn/fzf.vim.git"

  say ""
  say "Plugins installed under: $VIM_PACK_DIR"
  say "Note: fzf.vim works best if the 'fzf' binary exists (optional)."
}

should_install_plugins() {
  case "$PLUGINS" in
    1) return 0 ;;
    0) return 1 ;;
    *)
      if [[ -t 0 ]]; then
        prompt_yes_no \
          "Install Vim plugins (tokyonight, fugitive, airline, auto-pairs, fzf.vim)?" \
          "y"
      else
        # non-TTY default → INSTALL
        return 0
      fi
      ;;
  esac
}

main() {
  say "== minfiles: nice profile =="
  say "Repo:   $REPO_ROOT"
  say "Home:   $HOME_DIR"
  say "Mode:   $([[ "$COPY_MODE" == "1" ]] && echo copy || echo symlink)"
  say ""

  ensure_vim_dirs

  install_one "${PROFILE_DIR}/.bashrc" "${HOME_DIR}/.bashrc"
  install_one "${PROFILE_DIR}/.vimrc"  "${HOME_DIR}/.vimrc"

  say ""
  if should_install_plugins; then
    install_vim_plugins
  else
    say "Skipping plugin install."
  fi

  say ""
  say "Done."
  say "Tip: start a new shell or run: source ~/.bashrc"
}

main "$@"
