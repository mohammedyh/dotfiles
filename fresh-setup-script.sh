#!/bin/zsh

CYAN="\033[1;36m"
NOCOLOR="\033[0m"

printf "
  ${CYAN}Setup script to install apps and CLI utils on a fresh machine${NOCOLOR}
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

# Browsers
brew install --cask firefox --no-quarantine
brew install --cask google-chrome --no-quarantine

# Dev Apps
brew install --cask visual-studio-code --no-quarantine
brew install --cask tableplus --no-quarantine
brew install --cask iterm2 --no-quarantine
brew install --cask dbngin --no-quarantine
brew install --cask gitbutler --no-quarantine

# Notes Apps
brew install --cask obsidian --no-quarantine
brew install --cask notion --no-quarantine
brew install --cask ticktick --no-quarantine

# Util Apps
brew install --cask raycast --no-quarantine
brew install --cask cleanshot --no-quarantine
brew install --cask screen-studio --no-quarantine
brew install --cask 1password --no-quarantine
brew install --cask protonvpn --no-quarantine

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
cd ~/Downloads
gh repo clone mohammedyh/dotfiles

# copy iTerm2 config / preferences
cp -f ~/Downloads/dotfiles/.config/iterm2/com.googlecode.iterm2.plist ~/Library/Preferences

# copy .config folder
printf "
  ${CYAN}Copying files in .config/ and .zshrc to $HOME${NOCOLOR}
"
cp -R ~/Downloads/dotfiles/.config/* ~/.config
rm -rf ~/.config/iterm2
cp -f ~/Downloads/dotfiles/.zshrc $HOME
cp -f ~/Downloads/dotfiles/.gitconfig $HOME

cd ..

rm -rf ~/Downloads/dotfiles
touch ~/.hushlogin

# Install vscode extensions from list
for extension in $(cat ./dotfiles/vscode/extensions.txt); do
  code --install-extension $extension
done

# Copy vscode settings.json, keybindings.json and language snippets
cp -f ~/Downloads/dotfiles/vscode/settings.json ~/Library/Application\ Support/Code/User/
cp -f ~/Downloads/dotfiles/vscode/keybindings.json ~/Library/Application\ Support/Code/User/
cp -rf ~/Downloads/dotfiles/vscode/snippets ~/Library/Application\ Support/Code/User/

go install "github.com/mohammedyh/npr@latest"

# Import raycast settings using .rayconfig export file
printf "
  ${CYAN}Remember to import raycast settings using .rayconfig export file${NOCOLOR}
"

# Fonts
printf "
  ${CYAN}Next steps:

  - Install fonts: Dank Mono, MonoLisa, JetBrainsMono
  - Import .rayconfig file to import Raycast setting
  ${NOCOLOR}
"
