#!/bin/zsh

export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LESSHISTFILE=-
export LESS="-R"
export EDITOR=nvim
export VISUAL=nvim

autoload -U compinit && compinit
autoload -Uz bashcompinit && bashcompinit
autoload -U colors && colors

# Changing/making/removing directory
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

# Remove text highlight on paste
zle_highlight=("paste:none")

