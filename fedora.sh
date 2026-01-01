#!/usr/bin/env bash

set -eu
source ./_common.sh
source ./_brew.sh

OS_ALIAS="fedora"

update_dnf() {
  sudo dnf upgrade -y
}

add_docker_dnf_repo() {
  sudo dnf config-manager addrepo \
    --overwrite \
    --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo
}

enable_dnf_ghostty() { sudo dnf copr enable -y scottames/ghostty; }

dnf_install_pkg() {
  local items=()
  read_package_file_to_array "$OS_ALIAS" items
  [[ ${#items[@]} == 0 ]] && return
  echo_gray "found ${#items[@]} dnf packages to install"
  sudo dnf install -y "${items[@]}"
}

bootstrap() {
  update_dnf
  add_docker_dnf_repo
  enable_dnf_ghostty
  dnf_install_pkg
  install_brew
  update_brew
  brew_install_pkg "$OS_ALIAS-brew"
  install_or_update_rust
  install_or_update_aws_cli_linux
  install_or_update_aws_sam_cli_linux
  # install_gtk_theme
}

post_config_os() {
  add_brew_path_to_session
  post_config_linux

  link_home "bash/linux.sh" ".bashrc"
  link_home "zsh/linux.sh" ".zshrc"
}

do_update() {
  update_dnf
  update_brew
  install_or_update_rust
  install_or_update_aws_cli_linux
  install_or_update_aws_sam_cli_linux
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
