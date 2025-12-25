#!/usr/bin/env bash

IS_BREW_IN_PATH=""

is_arch() { [[ -f /etc/arch-release ]]; }
is_ubuntu() { [[ -f /etc/os-release ]] && grep -qi 'ubuntu' /etc/os-release; }
is_fedora() { [[ -f /etc/fedora-release ]]; }
is_mac() { [[ "$(uname -s)" == "Darwin" ]]; }

init_pacman_keyring() {
  sudo pacman-key --init
  sudo pacman-key --populate archlinux
  sudo pacman -Sy --needed --noconfirm archlinux-keyring
}

update_pacman() {
  sudo pacman -Syu --noconfirm
  sudo rm -rf /var/cache/pacman/pkg/download-*
  sudo pacman -Sc --noconfirm
}

install_yay() (
  command -v yay &>/dev/null && exit 0
  dir=$(mktemp -d)
  trap 'rm -rf "$dir"' EXIT
  git clone https://aur.archlinux.org/yay.git "$dir"
  cd "$dir" || exit 1
  makepkg -si --noconfirm
  yay -Y --gendb --noconfirm
)

update_yay() {
  yay -Syu --noconfirm
  yay -Yc --noconfirm
}

# Add brew to PATH for this session
add_brew_path_to_session() {
  [[ -n "$IS_BREW_IN_PATH" ]] && return 0
  if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    IS_BREW_IN_PATH="true"
  elif [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    IS_BREW_IN_PATH="true"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
    IS_BREW_IN_PATH="true"
  fi
}

install_brew() {
  add_brew_path_to_session
  command -v brew &>/dev/null && return 0
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  add_brew_path_to_session
}

update_brew() {
  add_brew_path_to_session
  brew update && brew upgrade && brew cleanup
}

update_apt() {
  sudo apt update &&
    sudo apt full-upgrade -y &&
    sudo apt autoremove -y &&
    sudo apt autoclean -y
}

update_dnf() {
  sudo dnf upgrade -y
}
