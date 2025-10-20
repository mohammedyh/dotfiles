#!/usr/bin/env bash

GREEN="\e[32m"
NOCOLOR="\e[0m"

cd "$HOME/Code" || (echo "$HOME/Code doesn't exist" && exit)
# projects=$(fd ^.git$ --type=d --hidden --exclude=/public,/vendor)

for project in $(fd ^.git$ --type=d --hidden --exclude=/public,/vendor); do
	projectPath="${project%/.git/}"

	printf "\n%brepo: %s%b\n" "$GREEN" "$projectPath" "$NOCOLOR"

	cd "$projectPath" || exit

  git fetch --all --prune
  git pull

	cd "$HOME/Code" || (echo "$HOME/Code doesn't exist" && exit)
done
