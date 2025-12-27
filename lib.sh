#!/usr/bin/env bash

IS_BREW_IN_PATH=""

CACHE_DIR=$HOME/.cache
SRC_CONFIG_DIR=$(pwd)/config
DEST_CONFIG_DIR=$HOME/.config
SRC_SERVICE_DIR=$(pwd)/service
DEST_SERVICE_DIR=$DEST_CONFIG_DIR/systemd/user

is_arch() { [[ -f /etc/arch-release ]]; }
is_ubuntu() { [[ -f /etc/os-release ]] && grep -qi 'ubuntu' /etc/os-release; }
is_fedora() { [[ -f /etc/fedora-release ]]; }
is_mac() { [[ "$(uname -s)" == "Darwin" ]]; }

pkg_file() {
  local filename
  is_arch && filename="arch"
  is_ubuntu && filename="ubuntu"
  is_fedora && filename="ubuntu"

  echo "$filename"
}

create_cache_dir() { mkdir -p "$CACHE_DIR"; }
create_config_dir() { mkdir -p "$DEST_CONFIG_DIR"; }

setup_terraform_plugin_cache() {
  mkdir -p "$CACHE_DIR/terraform-plugins"
  ln -sfn "$SRC_CONFIG_DIR/terraformrc" "$HOME/.terraformrc"
}

setup_git_config() {
  ln -sfn "$SRC_CONFIG_DIR/gitconfig" "$HOME/.gitconfig"
}

setup_arch_timezone() {
  sudo ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
  sudo hwclock --systohc
}

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
  [[ ! -d "$DEST_CONFIG_DIR/yay" ]] && {
    cp -r "$SRC_CONFIG_DIR/yay" "$DEST_CONFIG_DIR/yay"
  }
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

read_package_file_to_array() {
  local filename=$1
  local -n _arr=$2 # nameref to caller's array

  local filepath
  filepath="$(pwd)/pkg/$filename.txt"
  [[ ! -f "$filepath" ]] && return

  while IFS= read -r line || [[ -n "$line" ]]; do
    # Trim leading/trailing whitespace
    item=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    # Skip empty lines or lines starting with '#' or ';'
    if [[ -z "$item" || "$item" == \#* || "$item" == \;* ]]; then
      continue
    fi
    _arr+=("$item")
  done <"$filepath"
}

brew_install_pkg() {
  local -n items=$1 # nameref to caller's array
  [[ ${#items[@]} == 0 ]] && return
  printf "%s\n" "${items[@]}" | xargs brew install -q
}

yay_install_pkg() {
  local -n items=$1 # nameref to caller's array
  [[ ${#items[@]} == 0 ]] && return
  yay -S --needed --noconfirm "${items[@]}"
}

install_packages() {
  # shellcheck disable=SC2034
  local os_pkg=() brew_pkg=()
  if is_arch; then
    read_package_file_to_array "yay" os_pkg
    yay_install_pkg os_pkg
  elif is_ubuntu; then
    read_package_file_to_array "apt" os_pkg
  elif is_fedora; then
    read_package_file_to_array "dnf" os_pkg
  elif is_mac; then
    read_package_file_to_array "brew-mac" brew_pkg
    brew_install_pkg brew_pkg
  fi
}

install_or_update_rust() {
  ! command -v rustup &>/dev/null && return
  rustup default stable
  rustup update
}

install_or_update_aws_cli() (
  dir=$(mktemp -d)
  trap 'rm -rf "$dir"' EXIT
  cd "$dir" || exit 1
  local url filename
  url="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
  filename="awscliv2.zip"
  curl "$url" -o "$filename"
  unzip "$filename"
  sudo ./aws/install \
    --bin-dir /usr/local/bin \
    --install-dir /usr/local/aws-cli \
    --update
)

install_or_update_aws_sam_cli() (
  dir=$(mktemp -d)
  trap 'rm -rf "$dir"' EXIT
  cd "$dir" || exit 1
  local url filename dir_name
  url="https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip"
  filename="aws-sam-cli-linux-x86_64.zip"
  dir_name="sam-installation"
  curl -L "$url" -o "$filename"
  unzip "$filename" -d "$dir_name"
  sudo ./$dir_name/install --update
)

# install_devpod() (
#   dir=$(mktemp -d)
#   trap 'rm -rf "$dir"' EXIT
#   cd "$dir" || exit 1
#   local url
#   url="https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64"
#   curl -L -o devpod "$url" &&
#     sudo install -c -m 0755 devpod /usr/local/bin
# )
