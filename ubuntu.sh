#!/usr/bin/env bash

set -euo pipefail
source ./_common.sh
source ./_brew.sh

OS_ALIAS="ubuntu"

update_apt() {
  sudo apt update
  sudo apt full-upgrade -y
  sudo apt autoremove -y
  sudo apt autoclean -y
}

apt_install_pkg() {
  local items=()
  read_package_file_to_array "$OS_ALIAS" items
  [[ ${#items[@]} == 0 ]] && return
  echo_gray "found ${#items[@]} apt packages to install"
  sudo apt install -y "${items[@]}"
}

bootstrap() {
  update_apt
  apt_install_pkg
  install_brew
  update_brew
  brew_install_pkg "brew"
  brew_install_pkg "brew-$OS_ALIAS"
  install_or_update_rust
  install_or_update_aws_cli
  install_or_update_aws_sam_cli
  install_gtk_theme
}

post_config_os() {
  post_config_linux

  link_home "bash/linux.sh" ".bashrc"
  link_home "zsh/linux.sh" ".zshrc"
}

do_update() {
  update_apt
  update_brew
  install_or_update_rust
  install_or_update_aws_cli
  install_or_update_aws_sam_cli
}

main() {
  if should_config; then
    pre_config_generic
    post_config_os
    return
  elif should_update; then
    do_update
    return
  elif should_full; then
    pre_config_generic
    bootstrap
    post_config_os
    return
  fi
}

set_run_mode "$@"
main
