#!/usr/bin/env bash
[[ $- != *i* ]] && return

# -----------------------
# helpers
# -----------------------
have() { command -v "$1" >/dev/null 2>&1; }

# -----------------------
# core env (keep safe/portable)
# -----------------------
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-vim}"
export PAGER="${PAGER:-less}"

# Avoid hard-forcing locales on minimal servers (Alpine often lacks en_US.UTF-8)
export LANG="${LANG:-C.UTF-8}"
export LC_ALL="${LC_ALL:-}"

shopt -s checkwinsize 2>/dev/null || true

# Security-ish defaults (reasonable for servers)
umask 027
set -o noclobber

# XDG (safe, no mkdir side effects)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# -----------------------
# history
# -----------------------
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%F %T "
shopt -s histappend 2>/dev/null || true
PROMPT_COMMAND="history -a; ${PROMPT_COMMAND:-:}"

# -----------------------
# ls / colors (portable)
# -----------------------
if have dircolors; then
  eval "$(dircolors -b 2>/dev/null)" || true
fi

if have eza; then
  alias ls='eza --group-directories-first'
  alias ll='eza -l --group-directories-first --git'
  alias la='eza -la --group-directories-first --git'
else
  case "$OSTYPE" in
    linux*)
      alias ls='ls --color=auto'
      alias ll='ls -lh --color=auto'
      alias la='ls -lah --color=auto'
      ;;
    darwin*|*bsd*)
      export CLICOLOR=1
      alias ls='ls -G'
      alias ll='ls -lGh'
      alias la='ls -lah'
      ;;
    *)
      alias ll='ls -lh'
      alias la='ls -lah'
      ;;
  esac
fi

# -----------------------
# basic QoL aliases (minimal)
# -----------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias h='cd ~'
alias z='cd'
alias p='pwd'

alias c='cat'
alias v="$EDITOR"
alias grep='grep --color=auto'
alias cls='clear'
alias hi='history'

# Keep these mild; avoid surprises on servers
alias cp='cp -i'
alias cpr='cp -ir'
alias mv='mv -i'
alias m='mkdir -p'
# Intentionally NOT setting rm -i here (put that in "nice" if you want)

# Archive operations
alias ta='tar -czf archive.tar.gz'
alias ut='tar -xvf'
alias tarls='tar -tvf'
alias cx='chmod +x'

# SSH and hosts configuration
alias vc='vim ~/.ssh/config'
alias cc='cat ~/.ssh/config'
alias vh='vim /etc/hosts'
alias ch='cat /etc/hosts'

# Dotfile editing
alias va='vim ~/.bashrc'
alias vb='vim ~/.bashrc'
alias vv='vim ~/.vimrc'
alias sb='source ~/.bashrc'

# -----------------------
# git QoL (only if git exists)
# -----------------------
if have git; then
  alias g='git'
  alias gs='git status -sb'
  alias ga='git add'
  alias gaa='git add -A'
  alias gc='git commit'
  alias gcm='git commit -m'
  alias gca='git commit --amend'
  alias gco='git checkout'
  alias gcb='git checkout -b'
  alias gb='git branch'
  alias gbd='git branch -d'
  alias gpl='git pull --rebase'
  alias gp='git push'
  alias gpf='git push --force-with-lease'
  alias gl='git log --oneline --graph --decorate --max-count=20'
  alias gd='git diff'
  alias gds='git diff --staged'
  alias gsw='git switch'
  alias gsc='git switch -c'
  alias gst='git stash'
  alias gstp='git stash pop'
  alias gcl='git clean -fd'
  alias gwho='echo "user.name:" $(git config user.name) && echo "user.email:" $(git config user.email)'
  alias gn='git config user.name'
  alias ge='git config user.email'

  parse_git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/^/( /; s/$/)/'
  }
else
  parse_git_branch() { :; }
fi

# -----------------------
# prompt (simple + safe)
# -----------------------
# user@host:path (branch)$
PS1="\[\e[01;32m\]\u\[\e[0m\]@\[\e[01;33m\]\h\[\e[0m\]:\[\e[01;34m\]\w\[\e[0m\]\$(parse_git_branch)\$ "

# -----------------------
# local overrides (optional)
# -----------------------
[ -r "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
