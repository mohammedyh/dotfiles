#!/usr/bin/env bash

CYAN="\033[1;36m"
YELLOW="\033[1;33m"
NOCOLOR="\033[0m"

print() {
  printf "\n%b%s%b\n" "$CYAN" "$1" "$NOCOLOR"
}

print_warning() {
  printf "\n%b%s%b\n" "$YELLOW" "$1" "$NOCOLOR"
}

# Update npm and global packages
print "Updating bun, npm and global packages"
npm update -g
bun upgrade
bun -g update

# Update composer
print "Updating composer"
composer self-update

# Update global composer packages
print "Updating global composer packages"
composer global update

# Clear npm and pnpm cache
print "Clearing npm and pnpm cache"
pnpm store prune
npm cache clean --force
bun -g pm cache rm

# Clear composer cache
print "Clearing composer cache"
composer clear-cache

# Update Homebrew and formulae
print "Updating Homebrew and all formulae"
brew update
brew upgrade

# Remove unused formulae and clear Homebrew cache
print "Remove unused formulae and clear Homebrew cache"
brew autoremove
brew cleanup --prune=all -s

# Update Lazy plugins, Mason and Treesitter
print "Update Lazy plugins, Mason and Treesitter"
nvim --headless "+Lazy! sync" +qa > /dev/null
nvim --headless "+MasonUpdate" +qa > /dev/null
nvim --headless "+MasonToolsUpdate" +qa > /dev/null
nvim --headless -c "TSUpdate" -c "qa" > /dev/null

# Clean cache and update TLDR pages
print "Clear TLDR cache and update pages"
echo "y" | tldr --clean-cache
tldr --update

# Install LTS version of Node
print "Installing LTS version of node"
print "Current node version: $(fnm current)"
nodeInstallOutput=$(fnm install --lts 2>&1)

if [[ $nodeInstallOutput != *"Version already installed"* ]]; then
	printf "%s" "$nodeInstallOutput"
	fnm default lts-latest
  print "LTS version set as default"
	print "Remember to re-install pnpm"
else
	print_warning "Latest Node version already installed"
fi

print "Check system for potential brew problems"
brew doctor

print "Updates complete"

