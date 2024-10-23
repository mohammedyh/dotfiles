#!/bin/zsh

zmodload -i zsh/complist

WORDCHARS=""

unsetopt menu_complete   # Do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # Show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

zstyle ":completion:*:*:*:*:*" menu select

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
