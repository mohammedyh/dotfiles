#!/bin/zsh

CYAN="\033[1;36m"
YELLOW="\033[1;33m"
NOCOLOR="\033[0m"

# Update npm and global packages
echo "${CYAN}Updating global npm packages${NOCOLOR}"
npm update -g

# Clear corepack cache
# echo "${CYAN}Clearing corepack cache${NOCOLOR}"
# corepack cache clean

# Update composer
echo "\n${CYAN}Updating composer${NOCOLOR}"
composer self-update

# Update global composer packages
echo "\n${CYAN}Updating global composer packages${NOCOLOR}"
composer global update

# Clear npm and pnpm cache
echo "\n${CYAN}Clearing npm and pnpm cache${NOCOLOR}"
pnpm store prune
npm cache clean --force

# Clear composer cache
echo "\n${CYAN}Clearing composer cache${NOCOLOR}"
composer clear-cache

# Update Homebrew and formulae
echo "\n${CYAN}Updating Homebrew and all formulae${NOCOLOR}"
brew update
brew upgrade

# Remove unused formulae and clear Homebrew cache
echo "\n${CYAN}Remove unused formulae and clear all Homebrew cache${NOCOLOR}"
brew autoremove
brew cleanup --prune=all -s

# Update Lazy plugins, Mason and Treesitter
echo "\n${CYAN}Update Lazy plugins, Mason and Treesitter${NOCOLOR}"
nvim --headless "+Lazy! sync" +qa
nvim --headless "+MasonUpdate" +qa
nvim --headless -c "TSUpdate" -c "qa"

# Clean cache and update TLDR pages
echo "\n\n${CYAN}Clean cache and update TLDR pages${NOCOLOR}"
tldr --clean-cache
tldr --update

# Install LTS version of Node
echo "\n${CYAN}Install LTS version of Node${NOCOLOR}"
echo "${CYAN}Current Node version: $(fnm current)${NOCOLOR}"
nodeInstallOutput=$(fnm install --lts 2>&1)

if [[ $nodeInstallOutput != *"Version already installed"* ]] then
	echo $nodeInstallOutput
	fnm default lts-latest
	echo "\n${CYAN}Run 'fnm default lts-latest' and remove any old versions${NOCOLOR}"
	echo "\n${CYAN}To activate pnpm run 'corepack enable' and 'corepack prepare pnpm@latest --activate'${NOCOLOR}"
else
	echo "\n${YELLOW}Latest Node version already installed${NOCOLOR}"
fi

# Check for System, Safari, and App Store updates
# echo "\n${CYAN}Check for System, Safari, and App Store updates${NOCOLOR}"
# softwareupdate -ia

echo "\n${CYAN}Check system for potential (brew) problems${NOCOLOR}"
brew doctor

echo "\n${CYAN}Updates complete${NOCOLOR}"

