#!/bin/zsh

# Load brew and custom completions
fpath+=(~/.config/zsh/completions)
fpath+=("$(brew --prefix)/share/zsh/site-functions")
