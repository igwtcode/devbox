#!/usr/bin/env bash

set -euo pipefail
source ./_common.sh
source ./_brew.sh

OS_ALIAS="mac"

bootstrap() {
  install_brew
  update_brew
  brew_install_pkg "brew"
  brew_install_pkg "brew-mac"
  install_or_update_rust
  install_or_update_aws_cli_mac
  install_or_update_aws_sam_cli_mac
}

post_config_os() {
  post_config_generic
  link_home "bash/$OS_ALIAS.sh" ".bashrc"
  link_home "zsh/$OS_ALIAS.sh" ".zshrc"
}

do_update() {
  update_brew
  install_or_update_rust
  install_or_update_aws_cli_mac
  install_or_update_aws_sam_cli_mac
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
