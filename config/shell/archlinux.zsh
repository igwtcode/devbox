#!/usr/bin/env zsh
# vim: ft=zsh

source $HOME/.config/shell/common.zsh

export MOZ_ENABLE_WAYLAND=1

export PATH=$PATH:$HOME/.local/bin
export SUDO_ASKPASS=$HOME/.config/rofi/askpass.sh

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/nvm/init-nvm.sh

alias cp-awsprofile="sel-awsprofile | tr -d '\n' | wl-copy"
alias ch="cliphist list | fzf --no-sort -d $'\t' --with-nth 2 | cliphist decode | wl-copy"

# if [[ -n "$WAYLAND_DISPLAY" || -n "$DISPLAY" ]]; then
# fi
