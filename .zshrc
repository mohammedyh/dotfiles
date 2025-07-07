#!/bin/zsh

export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LESSHISTFILE=-
export LESS="-R"
export EDITOR=nvim
export VISUAL=nvim

# Load custom completions
fpath+=("$HOME/.config/zsh/completions")

# Default settings
autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit
autoload -U colors && colors

# Changing/making/removing directory
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

unsetopt menu_complete   # Do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # Show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

# Completion settings
zmodload -i zsh/complist

WORDCHARS=''

zstyle ":completion:*:*:*:*:*" menu select

zstyle ':completion:*:*:git:*' tag-order 'all-commands'

# Case insensitive (all), partial-word and substring completion
if [[ "$CASE_SENSITIVE" = true ]]; then
  zstyle ":completion:*" matcher-list "r:|=*" "l:|=* r:|=*"
else
  if [[ "$HYPHEN_INSENSITIVE" = true ]]; then
    zstyle ":completion:*" matcher-list "m:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}" "r:|=*" "l:|=* r:|=*"
  else
    zstyle ":completion:*" matcher-list "m:{[:lower:][:upper:]}={[:upper:][:lower:]}" "r:|=*" "l:|=* r:|=*"
  fi
fi
unset CASE_SENSITIVE HYPHEN_INSENSITIVE

# Complete . and .. special directories
zstyle ":completion:*" special-dirs true
zstyle ":completion:*" list-colors ""
zstyle ":completion:*:*:kill:*:processes" list-colors "=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01"

zstyle ":completion:*:*:*:*:processes" command "ps -u $USERNAME -o pid,user,comm -w -w"

# Disable named-directories autocompletion
zstyle ":completion:*:cd:*" tag-order local-directories directory-stack path-directories

# Use caching so that commands like apt and dpkg complete are useable
zstyle ":completion:*" use-cache yes
zstyle ":completion:*" cache-path $ZSH_CACHE_DIR

# Custom history command
function better_history {
  local clear list
  zparseopts -E c=clear l=list

  if [[ -n "$clear" ]]; then
    echo -n >| "$HISTFILE"
    fc -p "$HISTFILE"
    echo >&2 History file deleted.
  elif [[ -n "$list" ]]; then
    builtin fc "$@"
  else
    # Unless a number is provided, show all history events (starting from 1)
    [[ ${@[-1]-} = *[0-9]* ]] && builtin fc -l "$@" || builtin fc -l "$@" 1
  fi
}

alias history="better_history"

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000

## History command configuration
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
# setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# Keybind config
# Make sure that the terminal is in application mode when zle is active, since
# Only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

# Use emacs key bindings
bindkey -e

# [Ctrl-Delete] - delete whole forward-word
bindkey -M emacs '^[[3;5~' kill-word

# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
  # bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
  # bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search

  bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
  # bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
  # bindkey -M vicmd "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
  bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
  # bindkey -M viins "${terminfo[kcbt]}" reverse-menu-complete
  # bindkey -M vicmd "${terminfo[kcbt]}" reverse-menu-complete
fi

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey "\C-x\C-e" edit-command-line

# Remove text highlight on paste
zle_highlight=("paste:none")

# Aliases
# alias ls="ls --color=tty"
alias ls="eza"
alias l="ls -lah"
alias ll="ls -lh"
alias la="ls -lAh"
alias diff="diff --color"

alias grep="grep --color=auto --exclude-dir="{.bzr,CVS,.git,.hg,.svn,.idea,.tox}""
alias fgrep="grep -F --color=auto --exclude-dir="{.bzr,CVS,.git,.hg,.svn,.idea,.tox}""

alias pn="pnpm"
alias art="php artisan"
alias tinker="php artisan tinker"
alias clear_dns_cache="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias cmdhelp='compgen -c | fzf --style minimal --preview-window=right,70% --preview 'tldr --color always {}' | xargs tldr'

alias gst="git status"
alias ga="git add"
alias gapa="git add -p"
alias gp="git push"
alias gpfwl="git push --force-with-lease"
alias gcl="git clone"
alias glo="git log --oneline --decorate"
alias gb="git branch"
alias gba="git branch --all"
alias gsw="git switch"
alias gd="git diff"
alias gds="git diff --staged"
alias gf="git fetch"
alias gfap="git fetch --all --prune"
alias grs="git restore"
alias grst="git restore --staged"

# Load zsh plugins
source "$HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

eval "$(fnm env --use-on-cd)"
source <(fzf --zsh)

export FZF_ALT_C_OPTS="--walker-skip Library,Pictures,Music,.git,.bun,vendor,node_modules,target,.local --walker-root $HOME"
export FZF_CTRL_T_OPTS="--walker-skip Library,Pictures,Music,.git,.bun,vendor,node_modules,target,.local"

# Add Go bin, Composer and MySQL to PATH
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH=/Users/Shared/DBngin/mysql/8.0.33/bin:$PATH

eval "$(starship init zsh)"
