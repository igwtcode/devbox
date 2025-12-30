#!/usr/bin/env bash

set -eu
source ./_common.sh

OS_ALIAS="archlinux"
TIMEZONE=Europe/Berlin

init_pacman_keyring() {
  echo_gray "initializing pacman keyring..."
  sudo pacman-key --init
  sudo pacman-key --populate archlinux
  sudo pacman -Sy --needed --noconfirm archlinux-keyring
}

update_pacman() {
  echo_gray "updating pacman packages..."
  sudo pacman -Syu --noconfirm
  sudo rm -rf /var/cache/pacman/pkg/download-*
  sudo pacman -Sc --noconfirm
}

install_yay() (
  [[ ! -d "$DEST_CONFIG_DIR/yay" ]] && cp_config "yay"
  command -v yay &>/dev/null && {
    echo_gray "yay already installed"
    exit 0
  }
  echo_amber "installing yay..."
  dir=$(mktemp -d)
  trap 'rm -rf "$dir"' EXIT
  git clone https://aur.archlinux.org/yay.git "$dir"
  cd "$dir" || exit 1
  makepkg -si --noconfirm
  yay -Y --gendb --noconfirm
)

update_yay() {
  echo_gray "updating yay packages..."
  yay -Syu --noconfirm
  yay -Yc --noconfirm
}

yay_install_pkg() {
  local items=()
  read_package_file_to_array "$OS_ALIAS" items
  [[ ${#items[@]} == 0 ]] && return
  echo_gray "found ${#items[@]} yay packages to install"
  yay -S --needed --noconfirm "${items[@]}"
}

bootstrap() {
  setup_timezone
  init_pacman_keyring
  update_pacman
  install_yay
  update_yay
  yay_install_pkg
  install_or_update_rust
  install_or_update_aws_cli_linux
  install_or_update_aws_sam_cli_linux
  install_gtk_theme
}

post_config_os() {
  post_config_linux

  link_home "bash/$OS_ALIAS.sh" ".bashrc"
  link_home "zsh/$OS_ALIAS.sh" ".zshrc"
  link_home "zsh/$OS_ALIAS-profile.sh" ".zprofile"

  link_config "wallpaper"
  link_config "code-flags.conf"
  link_config "dunst"
  link_config "hypr"
  link_config "rofi"
  link_config "waybar"

  link_config "gtk-3.0"
  cp_config "gtk-4.0"
  link_config "qt5ct"
  link_config "qt6ct"

  setup_libvirt

  enable_service "acpid"
  enable_service "bluetooth"
  enable_service "fstrim.timer"
  enable_service "NetworkManager"
  enable_service "power-profiles-daemon"
}

do_update() {
  update_yay
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
