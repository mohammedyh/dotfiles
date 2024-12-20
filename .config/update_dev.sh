#!/bin/bash

# See if any of this can be parallelised

CYAN="\033[1;36m"
YELLOW="\033[1;33m"
NOCOLOR="\033[0m"

# Update npm and global packages
printf "\n%bUpdating global npm packages%b\n" "$CYAN" "$NOCOLOR"
npm update -g

# Clear corepack cache
# printf "%bClearing corepack cache%b\n" "$CYAN" "$NOCOLOR"
# corepack cache clean

# Update composer
printf "\n%bUpdating composer%b\n" "$CYAN" "$NOCOLOR"
composer self-update

# Update global composer packages
printf "\n%bUpdating global composer packages%b\n" "$CYAN" "$NOCOLOR"
composer global update

# Clear npm and pnpm cache
printf "\n%bClearing npm and pnpm cache%b\n" "$CYAN" "$NOCOLOR"
pnpm store prune
npm cache clean --force

# Clear composer cache
printf "\n%bClearing composer cache%b\n" "$CYAN" "$NOCOLOR"
composer clear-cache

# Update Homebrew and formulae
printf "\n%bUpdating Homebrew and all formulae%b\n" "$CYAN" "$NOCOLOR"
brew update
brew upgrade

# Remove unused formulae and clear Homebrew cache
printf "\n%bRemove unused formulae and clear all Homebrew cache%b\n" "$CYAN" "$NOCOLOR"
brew autoremove
brew cleanup --prune=all -s

# Update Lazy plugins, Mason and Treesitter
printf "\n%bUpdate Lazy plugins, Mason and Treesitter%b\n" "$CYAN" "$NOCOLOR"
nvim --headless "+Lazy! sync" +qa
nvim --headless "+MasonUpdate" +qa
nvim --headless -c "TSUpdate" -c "qa"

# Clean cache and update TLDR pages
printf "\n\n%bClean cache and update TLDR pages%b\n" "$CYAN" "$NOCOLOR"
tldr --clean-cache
tldr --update

# Install LTS version of Node
printf "\n%bInstalling LTS version of Node%b\n" "$CYAN" "$NOCOLOR"
printf "%bCurrent Node version: $(fnm current)%b\n" "$CYAN" "$NOCOLOR"
nodeInstallOutput=$(fnm install --lts 2>&1)

if [[ $nodeInstallOutput != *"Version already installed"* ]]; then
	printf "%s" "$nodeInstallOutput"
	fnm default lts-latest
	printf "\n%bLTS version set as default. Remove any old Node versions%b\n" "$CYAN" "$NOCOLOR"
	printf "\n%bTo activate pnpm run 'corepack enable' and 'corepack install --global pnpm@latest'%b\n" "$CYAN" "$NOCOLOR"
else
	printf "\n%bLatest Node version already installed%b\n" "$YELLOW" "$NOCOLOR"
fi

# Check for System, Safari, and App Store updates
# printf "\n%bCheck for System, Safari, and App Store updates%b\n" "$CYAN" "$NOCOLOR"
# softwareupdate -ia

printf "\n%bCheck system for potential (brew) problems%b\n" "$CYAN" "$NOCOLOR"
brew doctor

printf "\n%bUpdates complete%b\n" "$CYAN" "$NOCOLOR"
