#!/usr/bin/env bash

IS_BREW_IN_PATH=""

CACHE_DIR=$HOME/.cache
SRC_CONFIG_DIR=$(pwd)/config
DEST_CONFIG_DIR=$HOME/.config
SRC_SERVICE_DIR=$(pwd)/service
DEST_SERVICE_DIR=$DEST_CONFIG_DIR/systemd/user

echo_gray() { echo -e "\033[90m$1\033[0m"; }
echo_amber() { echo -e "\033[33m$1\033[0m"; }
echo_red() { echo -e "\033[31m$1\033[0m"; }
echo_green() { echo -e "\033[32m$1\033[0m"; }
echo_blue() { echo -e "\033[34m$1\033[0m"; }
echo_cyan() { echo -e "\033[36m$1\033[0m"; }
echo_magenta() { echo -e "\033[35m$1\033[0m"; }

is_arch() { [[ -f /etc/arch-release ]]; }
is_ubuntu() { [[ -f /etc/os-release ]] && grep -qi 'ubuntu' /etc/os-release; }
is_fedora() { [[ -f /etc/fedora-release ]]; }
is_mac() { [[ "$(uname -s)" == "Darwin" ]]; }

link_bin_dir() { ln -sfn "$(pwd)/bin" "$HOME/bin"; }
link_home() { ln -sfn "$SRC_CONFIG_DIR/$1" "$HOME/${2:-$1}"; }
link_config() { ln -sfn "$SRC_CONFIG_DIR/$1" "$DEST_CONFIG_DIR/${2:-$1}"; }

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
  link_home "terraformrc" ".terraformrc"
}

init() {
  echo_gray "initializing directories and base config..."
  create_cache_dir
  create_config_dir
  setup_terraform_plugin_cache
  link_home "gitconfig" ".gitconfig"
}

setup_arch_timezone() {
  echo_gray "setting timezone to Europe/Berlin..."
  sudo ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
  sudo hwclock --systohc
}

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
  [[ ! -d "$DEST_CONFIG_DIR/yay" ]] && {
    cp -r "$SRC_CONFIG_DIR/yay" "$DEST_CONFIG_DIR/yay"
  }
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
  command -v brew &>/dev/null && {
    echo_gray "homebrew already installed"
    return 0
  }
  echo_amber "installing homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  add_brew_path_to_session
}

update_brew() {
  echo_gray "updating homebrew packages..."
  add_brew_path_to_session
  brew update
  brew upgrade
  brew cleanup
}

update_apt() {
  sudo apt update
  sudo apt full-upgrade -y
  sudo apt autoremove -y
  sudo apt autoclean -y
}

update_dnf() {
  sudo dnf upgrade -y
}

prepare_os() {
  if is_arch; then
    echo_green "detected os: archlinux"
    setup_arch_timezone
    init_pacman_keyring
    update_pacman
    install_yay
    update_yay
  elif is_ubuntu; then
    echo_green "detected os: ubuntu"
    update_apt
  elif is_fedora; then
    echo_green "detected os: fedora"
    update_dnf
  elif is_mac; then
    echo_green "detected os: macos"
  fi

  if is_ubuntu || is_fedora || is_mac; then
    install_brew
    update_brew
  fi
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
  echo_gray "installing packages..."
  # shellcheck disable=SC2034
  local os_pkg=() brew_pkg=()
  if is_arch; then
    read_package_file_to_array "yay" os_pkg
    echo_gray "found ${#os_pkg[@]} packages to install"
    yay_install_pkg os_pkg
  elif is_ubuntu; then
    read_package_file_to_array "apt" os_pkg
  elif is_fedora; then
    read_package_file_to_array "dnf" os_pkg
  elif is_mac; then
    read_package_file_to_array "brew-mac" brew_pkg
    echo_gray "found ${#brew_pkg[@]} packages to install"
    brew_install_pkg brew_pkg
  fi
}

install_or_update_rust() {
  ! command -v rustup &>/dev/null && return
  echo_gray "updating rust toolchain..."
  rustup default stable
  rustup update
}

install_or_update_aws_cli() (
  echo_gray "installing/updating aws cli..."
  dir=$(mktemp -d)
  trap 'rm -rf "$dir"' EXIT
  cd "$dir" || exit 1
  local url filename
  url="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
  filename="awscliv2.zip"
  curl -sS "$url" -o "$filename"
  unzip -q "$filename"
  sudo ./aws/install \
    --bin-dir /usr/local/bin \
    --install-dir /usr/local/aws-cli \
    --update
)

install_or_update_aws_sam_cli() (
  echo_gray "installing/updating aws sam cli..."
  dir=$(mktemp -d)
  trap 'rm -rf "$dir"' EXIT
  cd "$dir" || exit 1
  local url filename dir_name
  url="https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip"
  filename="aws-sam-cli-linux-x86_64.zip"
  dir_name="sam-installation"
  curl -sSL "$url" -o "$filename"
  unzip -q "$filename" -d "$dir_name"
  sudo ./$dir_name/install --update
)

install_gtk_them() (
  for d in ~/.themes/*; do
    [[ ${d##*/} =~ [Cc]atppuccin ]] && return
  done

  local name="Catppuccin-GTK-Theme"
  echo_gray "installing $name..."
  dir=$(mktemp -d)
  trap 'rm -rf "$dir"' EXIT
  cd "$dir" || exit 1
  git clone --depth=1 https://github.com/Fausto-Korpsvart/$name.git
  cd "$name/themes" || exit 1
  ./install.sh -c dark -l -t all
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

setup_zsh_as_default() {
  if [[ "$(realpath "$SHELL")" != "$(which zsh)" ]]; then
    echo_amber "changing default shell to zsh..."
    sudo chsh -s "$(which zsh)" "$USER"
  fi
}

setup_tmux() {
  link_config "tmux"
  local tmux_tpm="$DEST_CONFIG_DIR/tmux/plugins/tpm"
  [[ -d "$tmux_tpm" ]] || {
    echo_gray "installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm "$tmux_tpm" &&
      "$tmux_tpm"/bin/install_plugins
  }
}

setup_services() {
  is_mac && return

  echo_gray "configuring system services..."
  # Add user to docker group for running docker without sudo
  sudo usermod -aG docker "$USER"

  local services=("docker")
  is_arch && services+=(
    "acpid"
    "bluetooth"
    "fstrim.timer"
    "NetworkManager"
    "power-profiles-daemon"
  )

  # Enable and start necessary services
  for svc in "${services[@]}"; do
    echo_gray "enabling service: $svc"
    sudo systemctl enable --now "$svc"
  done
}

setup_user_services() {
  is_mac && return
  mkdir -p "$DEST_SERVICE_DIR"

  echo_gray "configuring user services..."
  local services=("wl-paste.service")
  for svc in "${services[@]}"; do
    ln -sfn "$SRC_SERVICE_DIR/$svc" "$DEST_SERVICE_DIR/$svc"
  done
  systemctl --user daemon-reload
  for svc in "${services[@]}"; do
    echo_gray "enabling user service: $svc"
    systemctl --user enable --now "$svc"
  done
}

setup_libvirt() {
  is_mac && return
  ! command -v libvirtd &>/dev/null && return

  echo_gray "configuring libvirt/qemu-kvm..."

  # Add user to libvirt group for system-mode access
  sudo usermod -aG libvirt "$USER"

  # Enable and start libvirtd service
  echo_gray "enabling libvirtd service..."
  sudo systemctl enable --now libvirtd.service

  # Set default network to autostart
  echo_gray "enabling default virtual network..."
  sudo virsh net-autostart default 2>/dev/null || true
  sudo virsh net-start default 2>/dev/null || true

  # Set ACL on images directory for user access
  local images_dir="/var/lib/libvirt/images"
  if [[ -d "$images_dir" ]]; then
    echo_gray "setting ACL on $images_dir..."
    sudo setfacl -R -m "u:$USER:rwX" "$images_dir"
    sudo setfacl -m "d:u:$USER:rwx" "$images_dir"
  fi

  # virsh -c qemu:///system list --all
  # virt-manager
}

config_tools() {
  echo_gray "linking config files..."
  link_bin_dir
  link_home "vim" ".vim"
  link_home "vimrc" ".vimrc"
  link_config "nvim"
  link_config "eza"

  link_config "bat"
  # Rebuild bat cache for syntax highlighting
  bat cache --build &>/dev/null

  link_config "lazydocker"
  link_config "lazygit"
  link_config "starship"

  link_home "bashrc" ".bashrc"
  link_home "zshrc" ".zshrc"
  link_home "zprofile" ".zprofile"
  setup_zsh_as_default
  setup_tmux

  local os_alias
  if is_arch; then
    os_alias="archlinux"
  elif is_mac; then
    os_alias="mac"
  fi

  link_config "kitty"

  ln -sfn "$SRC_CONFIG_DIR/alacritty/$os_alias.toml" "$SRC_CONFIG_DIR/alacritty/alacritty.toml"
  link_config "alacritty"

  ln -sfn "$SRC_CONFIG_DIR/ghostty/$os_alias" "$SRC_CONFIG_DIR/ghostty/config"
  link_config "ghostty"

  link_config "wallpaper"
  link_config "k9s"

  if is_arch; then
    link_config "btop"
    # Fix btop Intel graphics issue (set performance monitoring capability)
    sudo setcap cap_perfmon=+ep "$(which btop)"

    link_config "code-flags.conf"
    link_config "dunst"
    link_config "hypr"
    link_config "rofi"
    link_config "waybar"
  fi

  if ! is_mac; then
    install_gtk_them
    link_config "gtk-3.0"
    link_config "gtk-4.0"
    link_config "qt5ct"
    link_config "qt6ct"
  fi
}
