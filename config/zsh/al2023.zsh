#!/usr/bin/env zsh
# vim: ft=zsh

source $HOME/.config/zsh/common.zsh

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# FIXME: check this
export PATH=$PATH:/home/linuxbrew/.linuxbrew/opt/libpq/bin

export NVM_DIR="$HOME/.nvm"
[ -d "$NVM_DIR" ] || {
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" &&
    (cd "$NVM_DIR" &&
      git checkout "$(git describe --abbrev=0 --tags --match 'v[0-9]*' $(git rev-list --tags --max-count=1))")
}
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
