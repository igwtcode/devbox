#!/usr/bin/env bash

set -euo pipefail
source ./lib.sh || source "$(dirname "$0")/lib.sh"
# source "${BASH_SOURCE[0]%/*}/lib.sh"

is_arch && {
  init_pacman_keyring
  update_pacman
  install_yay && update_yay
}

is_ubuntu && {
  update_apt
  install_brew && update_brew
}

is_fedora && {
  update_dnf
  install_brew && update_brew
}

is_mac && {
  install_brew && update_brew
}
