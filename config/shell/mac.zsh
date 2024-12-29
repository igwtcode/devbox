#!/usr/bin/env zsh
# vim: ft=zsh

source $HOME/.config/shell/common.zsh

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

eval "$(/opt/homebrew/bin/brew shellenv)"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH=$PATH:/opt/homebrew/opt/libpq/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

alias cp-awsprofile="sel-awsprofile | tr -d '\n' | pbcopy"
