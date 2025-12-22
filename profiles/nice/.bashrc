#!/usr/bin/env bash
[[ $- != *i* ]] && return

# -----------------------
# helpers
# -----------------------
have() { command -v "$1" >/dev/null 2>&1; }

# -----------------------
# core env (portable)
# -----------------------
export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-vim}"
export PAGER="${PAGER:-less}"

# Locale: safe across Debian/Ubuntu/Proxmox/Alpine
export LANG="${LANG:-C.UTF-8}"
export LC_ALL="${LC_ALL:-}"

shopt -s checkwinsize 2>/dev/null || true
shopt -s autocd 2>/dev/null || true
shopt -s cdspell 2>/dev/null || true

# Security-ish defaults (reasonable for servers)
umask 027
set -o noclobber
ulimit -c 0 2>/dev/null || true

# XDG (no mkdir side effects)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export MY_PROJECTS="${MY_PROJECTS:-$HOME/Projects}"

# -----------------------
# history
# -----------------------
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%F %T "
HISTIGNORE="ls:ll:la:cd:clear:exit"

shopt -s histappend 2>/dev/null || true
shopt -s cmdhist 2>/dev/null || true
shopt -s lithist 2>/dev/null || true

# Append to history each prompt, preserve existing PROMPT_COMMAND
if [[ -n "${PROMPT_COMMAND:-}" ]]; then
  PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
else
  PROMPT_COMMAND="history -a"
fi

# -----------------------
# colors / ls
# -----------------------
if have dircolors; then
  eval "$(dircolors -b 2>/dev/null)" || true
fi

if have eza; then
  alias ls='eza --group-directories-first'
  alias ll='eza -l --group-directories-first --git'
  alias la='eza -la --group-directories-first --git'
  alias lt='eza -T --git-ignore'
else
  # Keep basic; avoid GNU-only flags on BusyBox where possible
  if ls --help 2>&1 | grep -q -- '--color'; then
    alias ls='ls --color=auto'
    alias ll='ls -lh --color=auto'
    alias la='ls -lah --color=auto'
  else
    # macOS/BSD style
    export CLICOLOR=1
    alias ls='ls -G'
    alias ll='ls -lGh'
    alias la='ls -lah'
  fi
fi

# grep color only if supported
if grep --help 2>&1 | grep -q -- '--color'; then
  alias grep='grep --color=auto'
fi

# -----------------------
# navigation / QoL
# -----------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'
alias h='cd ~'
alias z='cd'
alias p='pwd'

alias cl='clear'
alias hi='history'
alias c='cat'
alias v="$EDITOR"

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

# Mild safety (servers): keep predictable defaults
alias cp='cp -i'
alias cpr='cp -ir'
alias mv='mv -i'
# If you *really* want rm -i on servers, keep it; otherwise comment it out.
alias rm='rm -i'

# mkdir convenience
alias mkdir='mkdir -p'
alias m='mkdir -p'

# tar helpers (GNU & BusyBox compatible)
alias ta='tar -czf'
alias ut='tar -xvf'
alias tarls='tar -tvf'
alias cx='chmod +x'

# safe kill helpers
alias pk='pkill -f'
alias k9='kill -9'

# verbose perms only if supported (GNU coreutils)
if chmod --help 2>&1 | grep -q -- ' -v'; then
  alias chmod='chmod -v'
fi
if chown --help 2>&1 | grep -q -- ' -v'; then
  alias chown='chown -v'
fi
if ln --help 2>&1 | grep -q -- ' -v'; then
  alias ln='ln -v'
fi

# -----------------------
# system helpers (guarded)
# -----------------------
have df   && alias df='df -h'
have du   && alias du='du -h'
have ps   && alias psa='ps aux'
have top  && alias top='top'
have free && alias free='free -h'

have ss      && alias listening='ss -lntup'
have netstat && alias listening='netstat -tulpen'
have lsof    && alias ports='lsof -i -P -n | grep LISTEN'

# iproute2 helpers (don't shadow `ip`)
if have ip; then
  # show addresses
  alias ipa='ip -c a'
  alias ip4='ip -c -4 a'
  alias ip6='ip -c -6 a'

  # routes
  alias ipr='ip -c r'
  alias ipr4='ip -c -4 r'
  alias ipr6='ip -c -6 r'

  # links / neighbors
  alias ipl='ip -c link'
  alias ipn='ip -c neigh'

  # quick default route
  ipgw() { ip -4 route show default; }
fi

# Tailscale (guarded)
have tailscale && {
  alias ts='tailscale status'
  alias tu='sudo tailscale up'
  alias td='sudo tailscale down'
}

# ZeroTier (guarded)
have zerotier-cli && {
  alias zt='sudo zerotier-cli'
  alias zs='sudo zerotier-cli status'
  alias zl='sudo zerotier-cli listnetworks'
  alias zp='sudo zerotier-cli peers'
}

# -----------------------
# modern cli (guarded)
# -----------------------
if have rg; then
  alias rg='rg --hidden --glob "!.git" --glob "!node_modules"'
fi
if have fd; then
  alias ff='fd --type f --hidden --exclude .git --exclude node_modules'
  alias fdd='fd --type d --hidden --exclude .git --exclude node_modules'
fi
if have fzf && have fd; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'
  if have bat; then
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --style=numbers --color=always {}'"
  else
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
  fi
  fcd() { local dir; dir="$(fd --type d --hidden --follow --exclude .git --exclude node_modules | fzf +m)" && cd "$dir"; }
fi

# -----------------------
# git (guarded)
# -----------------------
if have git; then
  alias g='git'
  alias gst='git status -sb'
  alias ga='git add'
  alias gaa='git add -A'
  alias gm='git commit -m'
  alias gca='git commit --amend'
  alias gco='git checkout'
  alias gcb='git checkout -b'
  alias gb='git branch'
  alias gpl='git pull --rebase'
  alias gc='git clone'
  alias gp='git push'
  alias gpf='git push --force-with-lease'
  alias glg='git log'
  alias glog='git log --graph --pretty=format:"%C(auto)%h%d %s %C(green)%cr %C(bold blue)<%an>%Creset"'
  alias gl='git log --oneline --graph --decorate --max-count=20'
  alias gdf='git diff'
  alias gds='git diff --staged'
  alias gcl='git clean -fd'
  alias gfe='git fetch'
  alias gre='git remote -v'
  alias gwho='echo "user.name:" $(git config user.name) && echo "user.email:" $(git config user.email)'
  alias gn='git config user.name'
  alias ge='git config user.email'

  have gitleaks && alias gdl='gitleaks detect'

  parse_git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/^/( /; s/$/)/'
  }
else
  parse_git_branch() { :; }
fi

# -----------------------
# 7. Proxmox (PVE Only)
# -----------------------
# These only activate if pveversion (Proxmox host) is detected
if have pveversion; then
  alias pve='pveversion -v'
  
  # LXC
  alias pl='pct list'
  alias pen='pct enter'
  alias pstart='pct start'
  alias pstop='pct stop'
  alias punlock='pct unlock'

  # VMs
  alias qm='qm'
  alias qml='qm list'
  alias qstart='qm start'
  alias qstop='qm stop'
  alias qshut='qm shutdown'
  alias qunlock='qm unlock'

  # Storage/Firewall
  alias psm='pvesm status'
  alias pw='pve-firewall status'
fi

# -----------------------
# prompt
# -----------------------
PS1="\[\e[01;32m\]\u\[\e[0m\]@\[\e[01;33m\]\h\[\e[0m\]:\[\e[01;34m\]\w\[\e[0m\]\$(parse_git_branch)\$ "

# local overrides (optional)
[ -r "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"
