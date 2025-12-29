# vim: ft=sh

source "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/_common.sh"

export LIBVIRT_DEFAULT_URI="qemu:///system"

source /usr/share/nvm/init-nvm.sh

alias cp-awsprofile="sel-awsprofile | tr -d '\n' | wl-copy"
alias task='go-task'
alias ch="cliphist list | fzf --no-sort -d $'\t' --with-nth 2 | cliphist decode | wl-copy"

[[ -f "$HOME/.customrc.sh" ]] && source $HOME/.customrc.sh
