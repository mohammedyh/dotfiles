#!/bin/zsh

source ~/.config/zsh/defaults.sh
source ~/.config/zsh/fpath.sh
source ~/.config/zsh/completion.sh
source ~/.config/zsh/history.sh
source ~/.config/zsh/aliases.sh

# Load plugins
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(fnm env --use-on-cd)"
source <(fzf --zsh)

export FZF_ALT_C_OPTS="--walker-skip Library,Pictures,Music,.git,.bun,vendor,node_modules,target,.local"
export FZF_CTRL_T_OPTS="--walker-skip Library,Pictures,Music,.git,.bun,vendor,node_modules,target,.local"

# Add Composer and MySQL to PATH
export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH=/Users/Shared/DBngin/mysql/8.0.33/bin:$PATH

eval "$(starship init zsh)"
