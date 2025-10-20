#!/usr/bin/env bash

export GOPROXY='direct'

RED="\033[30m"
GREEN="\033[32m"
BLUE_HIGHLIGHT="\033[34;7m"
BLUE="\033[34m"
NOCOLOR="\033[0m"

printf "%b Updating Go binaries %b\n\n" "$BLUE_HIGHLIGHT" "$NOCOLOR"

for bin in $(ls $HOME/go/bin); do
  if [ "$bin" == "golangci-lint" ]; then
    continue
  fi

  printf "%bUpdating $bin%b\n" "$GREEN" "$NOCOLOR"
  path=$(go version -m "$HOME/go/bin/$bin" | rg 'path' --stop-on-nonmatch | awk '{print $2}')

  if [ -z "$path" ]; then
      $printf "%bCouldn't get path for binary%b\n" "$RED" "$NOCOLOR"
      exit 1
  fi

  go install "$path@latest"
done

printf "\n%bGo binaries updated!%b\n" "$BLUE" "$NOCOLOR"
