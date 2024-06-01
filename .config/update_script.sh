#!/bin/zsh

CYAN="\033[1;36m"
NOCOLOR="\033[0m"

# Update npm and global packages
echo "${CYAN}Updating global npm packages${NOCOLOR}"
npm update -g

# Update bun
echo "\n${CYAN}Updating bun${NOCOLOR}"
bun upgrade

# Clear npm and pnpm cache
echo "\n${CYAN}Clearing npm and pnpm cache${NOCOLOR}"
pnpm store prune
npm cache clean --force

# Update Homebrew and formulae
echo "\n${CYAN}Updating Homebrew and all formulae${NOCOLOR}"
brew update
brew upgrade

# Remove unused formulae and clear Homebrew cache
echo "\n${CYAN}Remove unused formulae and clear all Homebrew cache${NOCOLOR}"
brew autoremove
brew cleanup --prune=all -s

# Clean cache and update TLDR pages
tldr --clean-cache
tldr --update

# Install LTS version of Node
echo "\n${CYAN}Install LTS version of Node${NOCOLOR}"
echo "${CYAN}Current Node version: $(fnm current)${NOCOLOR}"
fnm install --lts
echo "\n${CYAN}Set new LTS version as default by running 'fnm default lts-latest' and remove old version${NOCOLOR}"
echo "\n${CYAN}If a new version is installed, to activate pnpm run the following 'corepack enable' and 'corepack prepare pnpm@latest --activate'${NOCOLOR}"

# Update Lazy-NVIM and Mason
nvim --headless "+Lazy! sync" +qa
nvim --headless "+MasonUpdate" +qa

# Check for System, Safari, and App Store updates
# echo "\n${CYAN}Check for System, Safari, and App Store updates${NOCOLOR}"
# softwareupdate -ia

echo "\n${CYAN}Updates complete${NOCOLOR}"

