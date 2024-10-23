#!/bin/zsh

# Aliases
alias ls="ls --color=tty"
alias lsa="ls -lah"
alias l="ls -lah"
alias ll="ls -lh"
alias la="ls -lAh"
alias diff="diff --color"

alias grep="grep --color=auto --exclude-dir="{.bzr,CVS,.git,.hg,.svn,.idea,.tox}""
alias fgrep="grep -F --color=auto --exclude-dir="{.bzr,CVS,.git,.hg,.svn,.idea,.tox}""

# alias connect="kitten ssh"
# alias kdiff="kitten diff"
# alias icat="kitten icat"
# alias update_kitty="curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"

alias pn="pnpm"
alias art="php artisan"
alias tinker="php artisan tinker"
alias clear_dns_cache="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias cmdhelp="compgen -c | fzf | xargs tldr"
alias np-run="~/.config/np-run"

alias gst="git status"
alias ga="git add"
alias gapa="git add -p"
alias gp="git push"
alias gcl="git clone"
alias glo="git log --oneline --decorate"
alias gb="git branch"
alias gba="git branch --all"
alias gd="git diff"
alias gds="git diff --staged"
alias gf="git fetch"
alias gfap="git fetch --all --prune"
alias grs="git restore"
alias grst="git restore --staged"
