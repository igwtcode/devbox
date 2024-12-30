#!/usr/bin/env bash
# vim: ft=bash

source $HOME/.config/shell/bash/common.bash

export PATH=$PATH:/opt/homebrew/opt/libpq/bin

export NVM_DIR="$HOME/.nvm"
[ -d "$NVM_DIR" ] || {
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" &&
    (cd "$NVM_DIR" &&
      git checkout "$(git describe --abbrev=0 --tags --match 'v[0-9]*' $(git rev-list --tags --max-count=1))")
}
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

alias cp-awsprofile="sel-awsprofile | tr -d '\n' | pbcopy"
