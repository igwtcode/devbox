#!/usr/bin/env zsh

source "$(dirname "$(realpath ~/.zshrc)")/_common.sh"

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export LIBVIRT_DEFAULT_URI="qemu:///system"

export NVM_DIR="$HOME/.nvm"
[ -d "$NVM_DIR" ] || {
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR" &&
    (
      cd "$NVM_DIR" &&
        git checkout "$(git describe --abbrev=0 --tags --match 'v[0-9]*' $(git rev-list --tags --max-count=1))"
    )
}
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
syntax_highlighting_theme
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias cp-awsprofile="sel-awsprofile | tr -d '\n' | wl-copy"
alias task='go-task'
alias ch="cliphist list | fzf --no-sort -d $'\t' --with-nth 2 | cliphist decode | wl-copy"

[[ -f "$HOME/.customrc.sh" ]] && source $HOME/.customrc.sh
