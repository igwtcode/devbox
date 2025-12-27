#!/usr/bin/env bash

set -euo pipefail
source ./lib.sh || source "$(dirname "$0")/lib.sh"
# source "${BASH_SOURCE[0]%/*}/lib.sh"

create_cache_dir
create_config_dir
setup_terraform_plugin_cache
setup_git_config

if is_arch; then
  setup_arch_timezone
  init_pacman_keyring
  update_pacman
  install_yay && update_yay
elif is_ubuntu; then
  update_apt
elif is_fedora; then
  update_dnf
fi

if is_ubuntu || is_fedora || is_mac; then
  install_brew && update_brew
fi

install_packages
install_or_update_rust
install_or_update_aws_cli
install_or_update_aws_sam_cli
