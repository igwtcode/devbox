# vim: ft=sh

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/_common.sh"

export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:/opt/homebrew/opt/grep/libexec/gnubin:$PATH
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

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

eval "$(/opt/homebrew/bin/brew shellenv)"

alias cp-awsprofile="sel-awsprofile | tr -d '\n' | pbcopy"

[[ -f "$HOME/.customrc.sh" ]] && source $HOME/.customrc.sh
