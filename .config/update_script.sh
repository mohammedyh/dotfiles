#!/bin/zsh

CYAN="\033[1;36m"
NOCOLOR="\033[0m"

echo "${CYAN}Updating global npm packages${NOCOLOR}"
npm update -g

echo "\n${CYAN}Updating bun${NOCOLOR}"
bun upgrade

echo "\n${CYAN}Clearing npm and pnpm cache${NOCOLOR}"
pnpm store prune
npm cache clean --force

echo "\n${CYAN}Updating Homebrew and all formulae${NOCOLOR}"
brew update
brew upgrade

echo "\n${CYAN}Remove unused formulae and clear all Homebrew cache${NOCOLOR}"
brew autoremove
brew cleanup --prune=all

echo "\n${CYAN}Install LTS version of Node${NOCOLOR}"
echo "${CYAN}Current Node version: $(fnm current)${NOCOLOR}"
fnm install --lts
echo "\n${CYAN}Set new LTS version as default by running 'fnm default lts-latest' and remove old version${NOCOLOR}"
echo "\n${CYAN}If a new version is installed, to activate pnpm run the following 'corepack enable' and 'corepack prepare pnpm@latest --activate'${NOCOLOR}"

echo "\n${CYAN}Updates complete${NOCOLOR}"
