#!/usr/bin/env zsh

source "$(dirname "$(realpath ~/.zshrc)")/_common.sh"

export LIBVIRT_DEFAULT_URI="qemu:///system"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
syntax_highlighting_theme
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/nvm/init-nvm.sh

alias randraw="openssl rand -hex 32 | tr -d '\n' | wl-copy"
alias randbase64="openssl rand 60 | base64 -w 0 | tr -d '\n' | wl-copy"
alias cp-awsprofile="sel-awsprofile | tr -d '\n' | wl-copy"
alias task='go-task'
alias ch="cliphist list | fzf --no-sort -d $'\t' --with-nth 2 | cliphist decode | wl-copy"
alias k='kubectl'

_cmdfzf() {
  local list_cmd=$1
  local preview_cmd=$2
  local prompt=$3
  eval "$list_cmd" | fzf \
    --preview "$preview_cmd {}" \
    --preview-window=right:60%:wrap \
    --height=60% \
    --prompt="$prompt"
}

xpac() {
  local subcommand=$1

  case $subcommand in
  install)
    local pkg=$(_cmdfzf "yay -Slq" "yay -Si" "Install: ")
    [[ -z "$pkg" ]] && return
    gum confirm "Install $pkg?" && yay -S "$pkg"
    ;;
  remove)
    local pkg=$(_cmdfzf "yay -Qq" "yay -Qi" "Remove: ")
    [[ -z "$pkg" ]] && return
    gum confirm "Remove $pkg?" && yay -Rns "$pkg"
    ;;
  info)
    local pkg=$(_cmdfzf "yay -Qq" "yay -Qi" "Info: ")
    [[ -z "$pkg" ]] && return
    yay -Qi "$pkg"
    echo "━━━ Commands provided ━━━"
    pacman -Ql "$pkg" | grep '/usr/bin/' | awk -F'/' '{print "  " $NF}'
    echo -n "$pkg" | wl-copy
    echo "\n✓ Package name copied to clipboard"
    ;;
  *)
    echo "Usage: xpac {install|remove|info}"
    echo "  install - Install packages from repositories"
    echo "  remove  - Remove installed packages"
    echo "  info    - View package information"
    return 1
    ;;
  esac
}
_xpac_completion() {
  local -a subcommands
  subcommands=(
    'install:Install packages from repositories'
    'remove:Remove installed packages'
    'info:View package information'
  )
  _describe 'xpac subcommands' subcommands
}
compdef _xpac_completion xpac

xsvc() {
  local subcommand=$1
  local list_cmd="systemctl list-unit-files --type=service --all --no-pager --no-legend | awk '{print \$1}'"
  local preview_cmd="systemctl status --no-pager"

  case $subcommand in
  info)
    local svc=$(_cmdfzf "$list_cmd" "$preview_cmd" "Service Info: ")
    [[ -z "$svc" ]] && return
    systemctl status --no-pager "$svc"
    echo -n "$svc" | wl-copy
    echo "\n✓ Service name copied to clipboard"
    ;;
  start)
    local svc=$(_cmdfzf "$list_cmd" "$preview_cmd" "Start: ")
    [[ -z "$svc" ]] && return
    gum confirm "Start $svc?" && sudo systemctl start "$svc"
    ;;
  stop)
    local svc=$(_cmdfzf "$list_cmd" "$preview_cmd" "Stop: ")
    [[ -z "$svc" ]] && return
    gum confirm "Stop $svc?" && sudo systemctl stop "$svc"
    ;;
  restart)
    local svc=$(_cmdfzf "$list_cmd" "$preview_cmd" "Restart: ")
    [[ -z "$svc" ]] && return
    gum confirm "Restart $svc?" && sudo systemctl restart "$svc"
    ;;
  enable)
    local svc=$(_cmdfzf "$list_cmd" "$preview_cmd" "Enable: ")
    [[ -z "$svc" ]] && return
    gum confirm "Enable $svc?" && sudo systemctl enable "$svc"
    ;;
  disable)
    local svc=$(_cmdfzf "$list_cmd" "$preview_cmd" "Disable: ")
    [[ -z "$svc" ]] && return
    gum confirm "Disable $svc?" && sudo systemctl disable "$svc"
    ;;
  *)
    echo "Usage: xsvc {info|start|stop|restart|enable|disable}"
    echo "  info    - View service status"
    echo "  start   - Start a service"
    echo "  stop    - Stop a service"
    echo "  restart - Restart a service"
    echo "  enable  - Enable on boot"
    echo "  disable - Disable on boot"
    return 1
    ;;
  esac
}
_xsvc_completion() {
  local -a subcommands
  subcommands=(
    'info:View service status'
    'start:Start a service'
    'stop:Stop a service'
    'restart:Restart a service'
    'enable:Enable service on boot'
    'disable:Disable service on boot'
  )
  _describe 'xsvc subcommands' subcommands
}
compdef _xsvc_completion xsvc


export TASK_EXE='go-task'
eval "$(task --completion zsh)"

[[ -f "$HOME/.customrc.sh" ]] && source $HOME/.customrc.sh
