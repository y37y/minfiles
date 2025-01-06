#!/usr/bin/env bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#######################
# Core Configuration #
#######################

# Core environment setup
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export MY_PROJECTS="$HOME/Projects"

# Directory creation with error checking
create_dir() {
    if ! mkdir -p "$1" 2>/dev/null; then
        echo "Error: Failed to create directory $1" >&2
        return 1
    fi
}

# Create essential directories with error checking
for dir in "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME" "$XDG_CACHE_HOME" "$MY_PROJECTS"; do
    create_dir "$dir"
done

# Security settings for server environments
umask 027  # More restrictive file permissions by default
TMOUT=900  # Auto logout after 15 minutes of inactivity
readonly TMOUT
export TMOUT

# Disable core dumps for security
ulimit -c 0

#######################
# History Settings    #
#######################
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=10000
HISTFILESIZE=20000
HISTTIMEFORMAT="%F %T "
HISTIGNORE="ls:ll:la:cd:clear:exit"
shopt -s histappend
shopt -s cmdhist
shopt -s lithist

#######################
# Program Detection   #
#######################
# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

#######################
# System Aliases      #
#######################
# System monitoring
alias df='df -h'
alias free='free -h'
alias du1='du -h --max-depth=1'
alias du='du -h'
alias psa='ps aux'
alias psr='ps aux | grep'
alias ports='lsof -i -P | grep LISTEN'
alias neth='netstat -tulpn | grep LISTEN'
alias pk='pkill -f'
alias k9='kill -9'
alias disks='df -P -kHl'
alias ts='date +%Y-%m-%d.%H:%M:%S'

# Enhanced monitoring
alias dfh='df -h | grep -v "/snap/"'
alias meminfo='free -m | grep -v "Swap"'
alias cpuinfo='cat /proc/cpuinfo | grep "model name" | head -1'
alias sysload='uptime | sed "s/.*load average: //"'
alias connections='netstat -nat | grep ESTABLISHED | wc -l'
alias psme='ps aux | grep $USER'
alias psmem='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3 | head -10'

# System monitoring functions
monitor_system() {
    watch -n 1 "echo 'Memory Usage:'; free -h; echo; echo 'CPU Load:'; uptime; echo; echo 'Disk Usage:'; df -h /"
}

check_disk_space() {
    df -h | awk '{ if($5 > "80%") print $0 }'
}

#######################
# File Operations     #
#######################
# Basic operations
alias rm='rm -v -i'
alias rmd='rm -v -i -rf'
alias cp='cp -v -i'
alias mv='mv -v -i'
alias mkdir='mkdir -p'
alias m='mkdir -p'
alias c='cat'
alias v='vim'
alias cl='clear'
alias hi='history'
alias where='which'
alias ln='ln -v'
alias chmod='chmod -v'
alias chown='chown -v'

# Archive operations
alias ta='tar -czf archive.tar.gz'
alias ut='tar -xvf'
alias tarls='tar -tvf'
alias cx='chmod +x'

#######################
# Navigation         #
#######################
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'
alias cd.='cd $(readlink -f .)'
alias h='cd ~'
alias p='pwd'

#######################
# Modern CLI Tools    #
#######################
# eza (modern ls replacement)
if command_exists eza; then
    alias ls='eza --group-directories-first'
    alias ll='eza -l --group-directories-first --git'
    alias la='eza -la --group-directories-first --git --octal-permissions'
    alias lt='eza -T --git-ignore'
    alias l.='eza -d .*'
    alias lsize='eza -l --sort=size --reverse'
    alias lmod='eza -l --sort=modified --reverse'
else
    # Traditional ls aliases with color support
    case "$OSTYPE" in
        linux*)
            alias ls='ls --color=auto'
            alias ll='ls -lh --color=auto'
            alias la='ls -lah --color=auto'
            alias l='ls -CF --color=auto'
            ;;
        darwin*|*bsd*)
            export CLICOLOR=1
            export LSCOLORS=GxFxCxDxBxegedabagaced
            alias ls='ls -G'
            alias ll='ls -lGFh'
            alias la='ls -lah'
            alias l='ls -G'
            ;;
    esac
fi

# ripgrep configuration
if command_exists rg; then
    export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"
    alias rg='rg --hidden --glob "!.git" --glob "!node_modules"'
    create_dir "$(dirname "$RIPGREP_CONFIG_PATH")"
fi

# fd configuration
if command_exists fd; then
    alias ff='fd --type f --hidden --exclude .git --exclude node_modules'
    alias fd='fd --type d --hidden --exclude .git --exclude node_modules'
fi

# fzf configuration
if command_exists fzf; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --preview 'bat --style=numbers --color=always {}'"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git --exclude node_modules"
    
    # Source fzf keybindings and completion
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
    
    # Custom fzf functions
    fcd() {
        local dir
        dir=$(fd --type d --hidden --follow --exclude .git --exclude node_modules | fzf +m) &&
        cd "$dir"
    }
    
    fh() {
        eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
    }

    # Enhanced find in files with preview
    fif() {
        if [ ! "$#" -gt 0 ]; then
            echo "Need a string to search for!"
            return 1
        fi
        rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
    }
fi

#######################
# Network Tools       #
#######################
# Network troubleshooting functions
portcheck() {
    nc -zv "$1" "$2" 2>&1
}

ssht() {
    ssh -T "$1" 2>&1 | grep -q "success" && echo "SSH connection successful" || echo "SSH connection failed"
}

# Network aliases
alias myip='curl -s ifconfig.me'
alias localip="ip -c a | grep -w 'inet' | cut -d' ' -f6"
alias ping='ping -c 4'
alias fastping='ping -c 100 -s.2'
alias ports='netstat -tulanp'
alias listening='netstat -vtlnp --listening'
alias s='ssh'
alias sa='ssh-add'
alias sl='ssh-add -l'
alias sd='ssh-add -D'
alias pg='ping google.com'
alias ip='ip -c a'
alias ns='nslookup'

#######################
# Git Configuration   #
#######################
if command_exists git; then
    # Basic operations
    alias g='git'
    alias gs='git status -sb'
    alias ga='git add'
    alias gaa='git add --all'
    alias gp='git push'
    alias gpl='git pull'
    alias gc='git clone'
    
    # Commit operations
    alias gm='git commit -am'
    alias gcm='git commit -m'
    alias gca='git commit -v --amend'
    
    # Branch and checkout
    alias gco='git checkout'
    alias gcb='git checkout -b'
    alias gbranch='git branch'
    alias gst='git status -sb'
    
    # Diff and log
    alias gd='gitleaks detect'
    alias gds='git diff --staged'
    alias gdf='git diff'
    alias glo='git log --oneline --graph'
    alias glg='git log'
    alias glog='git log --graph --pretty=format:"%C(auto)%h%d %s %C(green)%cr %C(bold blue)<%an>%Creset"'

    # Git diff with more detail
    alias gdfs='git diff --staged'
    alias gdw='git diff --word-diff'
    alias gdt='git difftool'
    
    # Additional git aliases from your fish config
    alias gch='git checkout -b'
    alias gsh='git stash'
    alias gstsh='git stash'
    alias gpristine='git reset --hard && git clean -fdx'
    alias gfe='git fetch'
    
    # Forgejo specific (if you use it)
    alias gf='git push forgejo'
    alias gpf='git push origin && git push forgejo'
    alias gff='git fetch forgejo'
    alias gfu='git fetch upstream'
    alias gfm='git push forgejo main'
    
    # Remote operations
    alias gre='git remote -v'
    alias gref='git reflog'
    
    # Stash operations
    alias gstash='git stash'
    alias gpop='git stash pop'
    
    # Clean and reset
    alias gclean='git clean -fd'
    alias greset='git reset --hard'
    
    # Information
    alias gwho='echo "user.name:" $(git config user.name) && echo "user.email:" $(git config user.email)'
fi

#######################
# GPG Configuration   #
#######################
# GPG setup
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
create_dir "$GNUPGHOME"
chmod 700 "$GNUPGHOME"

# Set TTY for GPG
export GPG_TTY=$(tty)

# Start gpg-agent if not running
if ! pgrep -x "gpg-agent" >/dev/null; then
    gpg-agent --daemon 2>/dev/null || echo "Failed to start gpg-agent"
fi

# Set SSH to use GPG
if gpgconf --list-dirs agent-ssh-socket >/dev/null 2>&1; then
    unset SSH_AGENT_PID
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

# GPG aliases
alias gup='gpg --refresh-keys && gpg --update-trustdb'
alias glk='gpg --list-keys'
alias gls='gpg --list-secret-keys --keyid-format LONG'
alias glka='gpg --list-keys --keyid-format LONG --with-fingerprint'
alias gexp='gpg --export -a'
alias gexps='gpg --export-secret-key -a'
alias gen='gpg --encrypt --sign --armor'
alias gde='gpg --decrypt'
alias gsi='gpg --sign --detach-sign --armor'
alias gve='gpg --verify'
alias gsc='git -c commit.gpgsign=true commit'
alias gtl='git tag -s -m'
alias gse='gpg --send-keys'
alias grec='gpg --recv-keys'
alias gki='gpg --import'
alias gkt='gpg --edit-key'
alias glp='gpg --list-packets'
alias gpgv='gpg --verbose --list-packets'
alias gpgd='gpg --debug-all'
alias gpgdp='gpg --debug-all --list-packets'
alias gpgdv='gpg --debug-level advanced --verbose'

#######################
# Tmux Configuration  #
#######################
if command_exists tmux; then
    alias t='tmux'
    alias ta='tmux attach -t'
    alias tad='tmux attach -d -t'
    alias ts='tmux new-session -s'
    alias tl='tmux list-sessions'
    alias tksv='tmux kill-server'
    alias tkss='tmux kill-session -t'
    alias tr='tmux source-file ~/.tmux.conf'
fi

#######################
# Development Tools   #
#######################
# Python virtual environment
if command_exists python3; then
    alias py='python3'
    alias py2='python2'
    alias pyvenv='python3 -m venv'
    alias activate='source ./venv/bin/activate'
fi

# Node.js
if command_exists node; then
    alias nr='npm run'
    alias ni='npm install'
    alias nid='npm install --save-dev'
    alias nig='npm install -g'
    alias nup='npm update'
    alias nout='npm outdated'
    alias nls='npm list --depth=0'
fi

#######################
# Error Logging       #
#######################
BASH_ERROR_LOG="$HOME/.bash_errors.log"

log_error() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> "$BASH_ERROR_LOG"
}

# Trap errors
trap 'log_error "Last command failed with exit code $?"' ERR

#######################
# Prompt Configuration#
#######################
# Git branch parsing
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# System load and memory info
get_load() {
    uptime | awk -F'load average:' '{ print $2 }' | cut -d, -f1
}

get_memory() {
    free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2 }'
}

# Set prompt
if [[ ${EUID} == 0 ]]; then
    PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
else
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(parse_git_branch)\[\033[00m\] $(if [ $? -ne 0 ]; then echo "\[\033[01;31m\](err)\[\033[00m\]"; fi)[\l:\[\033[01;36m\]$(get_load)\[\033[00m\]|\[\033[01;35m\]$(get_memory)\[\033[00m\]]\$ '
fi

#######################
# Cleanup            #
#######################
cleanup() {
    find /tmp -type f -atime +7 -delete 2>/dev/null
    find "$HOME/.cache" -type f -atime +30 -delete 2>/dev/null
    find "$HOME" -name "*.tmp" -type f -delete 2>/dev/null
}

# Source local customizations
if [ -f "$HOME/.bashrc.local" ]; then
    source "$HOME/.bashrc.local"
fi

# Source additional configurations
for config in "$XDG_CONFIG_HOME/bash/conf.d/"*.bash ; do
    [ -r "$config" ] && source "$config"
done
