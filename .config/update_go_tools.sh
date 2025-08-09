#!/usr/bin/env bash

export GOPROXY='direct'

RED="\033[30m"
GREEN="\033[32m"
BLUE="\033[34m"
BLUEHIGHLIGHT="\033[34;7m"
NOCOLOR="\033[0m"

printf "%b Updating Go binaries \n\n%b" "$BLUEHIGHLIGHT" "$NOCOLOR"

for bin in $(ls $HOME/go/bin); do
    printf "%bUpdating $bin%b\n" "$GREEN" "$NOCOLOR"
    path=$(go version -m "$HOME/go/bin/$bin" | rg 'path' --stop-on-nonmatch | awk '{print $2}')

    if [ -z "$path" ]; then
        $printf "%bCouldn't get path for binary%b\n" "$RED" "$NOCOLOR"
        exit 1
    fi

    go install "$path@latest"
done

printf "\n%bGo binaries updated!%b\n" "$BLUE" "$NOCOLOR"
