#!/usr/bin/env bash

export GOPROXY='direct'

RED="\033[30m"
GREEN="\033[32m"
BLUE_HIGHLIGHT="\033[34;7m"
BLUE="\033[34m"
NOCOLOR="\033[0m"
binaries=$(fd . "$HOME/go/bin" -E 'golangci-lint')

printf "\n%b Updating Go binaries %b\n\n" "$BLUE_HIGHLIGHT" "$NOCOLOR"

for bin in $binaries; do
  printf "%bUpdating %s%b\n" "$GREEN" "$(basename $bin)" "$NOCOLOR"
  path=$(go version -m "$bin" | rg 'path' --stop-on-nonmatch | awk '{print $2}')

  if [ -z "$path" ]; then
      $printf "%bBinary path not found%b\n" "$RED" "$NOCOLOR"
      exit 1
  fi

  go install "$path@latest"
done

printf "\n%bGo binaries updated!%b\n" "$BLUE" "$NOCOLOR"
