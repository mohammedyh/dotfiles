#!/usr/bin/env bash

CYAN="\033[1;36m"
NOCOLOR="\033[0m"

printf "
  ${CYAN}Setup script to install apps and CLI utils on a new machine${NOCOLOR}
"

# Spotlight
defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1

# Dock
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock show-recents -bool false

# Finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

defaults write NSGlobalDomain AppleKeyboardUIMode -int 2
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

killall Finder
killall Dock

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Command Line Utils
brew install fnm
brew install bat
brew install delta
brew install doggo
brew install eza
brew install exiftool
brew install composer
brew install fzf
brew install fd
brew install gh
brew install git
brew install go
brew install jq
brew install neovim
brew install php
brew install ripgrep
brew install starship
brew install tlrc
brew install mailpit
brew install charmbracelet/tap/freeze
brew install vhs
brew install zoxide

export HOMEBREW_CASK_OPTS="--no-quarantine"
# Browsers
brew install --cask firefox
brew install --cask google-chrome

# Dev Apps
brew install --cask visual-studio-code
brew install --cask tableplus
brew install --cask iterm2
brew install --cask dbngin
brew install --cask gitbutler

# Notes Apps
brew install --cask obsidian
brew install --cask notion
brew install --cask ticktick

# Util Apps
brew install --cask raycast
brew install --cask cleanshot
brew install --cask screen-studio
brew install --cask 1password
brew install --cask protonvpn

export HOMEBREW_CASK_OPTS=""
brew doctor

# Disable Brew and Go analytics
go telemetry off
brew analytics off

# Install Node LTS Version
fnm install --lts

# Setup Git / GitHub
gh auth login
gh auth setup-git

printf "
  ${CYAN}Cloning dotfiles repo${NOCOLOR}
"
cd "$HOME/Downloads"
gh repo clone mohammedyh/dotfiles

# Copy iTerm2 config / preferences
cp -f "$HOME/Downloads/dotfiles/.config/iterm2/com.googlecode.iterm2.plist" "$HOME/Library/Preferences"

# Copy .config folder
printf "
  ${CYAN}Copying files in .config/ and .zshrc to $HOME${NOCOLOR}
"
cp -r "$HOME/Downloads/dotfiles/.config/*" "$HOME/.config"
rm -rf "$HOME/.config/iterm2"
cp -f "$HOME/Downloads/dotfiles/.zshrc" $HOME
cp -f "$HOME/Downloads/dotfiles/.gitconfig" $HOME

cd ../

rm -rf "$HOME/Downloads/dotfiles"
touch "$HOME/.hushlogin"

# Copy vscode settings.json, keybindings.json and language snippets
cp -f "$HOME/Downloads/dotfiles/vscode/settings.json" "$HOME/Library/Application\ Support/Code/User/"
cp -f "$HOME/Downloads/dotfiles/vscode/keybindings.json" "$HOME/Library/Application\ Support/Code/User/"
cp -rf "$HOME/Downloads/dotfiles/vscode/snippets" "$HOME/Library/Application\ Support/Code/User/"

# Install vscode extensions from list
for extension in $(cat ./dotfiles/vscode/extensions.txt); do
  code --install-extension $extension
done

# Install Node package runner helper
go install "github.com/mohammedyh/npr@latest"

# Import raycast settings using .rayconfig export file
printf "
  ${CYAN}Next steps:

  - Add fonts
  - Import Raycast config
  ${NOCOLOR}
"
