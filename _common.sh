#!/usr/bin/env bash

CACHE_DIR=$HOME/.cache
SRC_CONFIG_DIR=$(pwd)/config
DEST_CONFIG_DIR=$HOME/.config
SRC_SERVICE_DIR=$(pwd)/service
DEST_SERVICE_DIR=$DEST_CONFIG_DIR/systemd/user
RUN_MODE=""

echo_gray() { echo -e "\033[90m$1\033[0m"; }
echo_amber() { echo -e "\033[33m$1\033[0m"; }
echo_red() { echo -e "\033[31m$1\033[0m"; }
echo_green() { echo -e "\033[32m$1\033[0m"; }
echo_blue() { echo -e "\033[34m$1\033[0m"; }
echo_cyan() { echo -e "\033[36m$1\033[0m"; }
echo_magenta() { echo -e "\033[35m$1\033[0m"; }

link_bin_dir() { ln -sfn "$(pwd)/bin" "$HOME/bin"; }
link_home() { ln -sfn "$SRC_CONFIG_DIR/$1" "$HOME/${2:-$1}"; }
link_config() { ln -sfn "$SRC_CONFIG_DIR/$1" "$DEST_CONFIG_DIR/${2:-$1}"; }

link_alacritty() {
  local filepath
  filepath="$SRC_CONFIG_DIR/alacritty/$OS_ALIAS.toml"
  [[ ! -f "$filepath" ]] && filepath="$SRC_CONFIG_DIR/alacritty/linux.toml"
  [[ ! -f "$filepath" ]] && filepath="$SRC_CONFIG_DIR/alacritty/archlinux.toml"
  ln -sfn "$filepath" "$SRC_CONFIG_DIR/alacritty/alacritty.toml"
  link_config "alacritty"
}

link_ghostty() {
  local filepath
  filepath="$SRC_CONFIG_DIR/ghostty/$OS_ALIAS"
  [[ ! -f "$filepath" ]] && filepath="$SRC_CONFIG_DIR/ghostty/linux"
  [[ ! -f "$filepath" ]] && filepath="$SRC_CONFIG_DIR/ghostty/archlinux"
  ln -sfn "$filepath" "$SRC_CONFIG_DIR/ghostty/config"
  link_config "ghostty"
}

enable_service() { sudo systemctl enable --now "$1"; }

setup_user_service() {
  local svc
  svc="$1"
  mkdir -p "$DEST_SERVICE_DIR"
  ln -sfn "$SRC_SERVICE_DIR/$svc" "$DEST_SERVICE_DIR/$svc"
  systemctl --user daemon-reload
  systemctl --user enable --now "$svc"
}

setup_timezone() {
  local tz
  tz="${TIMEZONE:-Europe/Berlin}"
  echo_gray "setting timezone to $tz..."
  sudo ln -sf /usr/share/zoneinfo/"$tz" /etc/localtime
  sudo hwclock --systohc
}

create_cache_dir() { mkdir -p "$CACHE_DIR"; }
create_config_dir() { mkdir -p "$DEST_CONFIG_DIR"; }

setup_terraform_plugin_cache() {
  mkdir -p "$CACHE_DIR/terraform-plugins"
  link_home "terraformrc" ".terraformrc"
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

install_or_update_rust() {
  ! command -v rustup &>/dev/null && return
  echo_gray "updating rust toolchain..."
  rustup default stable
  rustup update
}

install_or_update_aws_cli_linux() (
  echo_gray "installing/updating aws cli..."
  dir=$(mktemp -d)
  trap 'rm -rf "$dir"' EXIT
  cd "$dir" || exit 1
  local url filename
  filename="awscli-exe-linux-x86_64.zip"
  url="https://awscli.amazonaws.com/$filename"
  curl -sS "$url" -o "$filename"
  unzip -q "$filename"
  sudo ./aws/install \
    --bin-dir /usr/local/bin \
    --install-dir /usr/local/aws-cli \
    --update
)

install_or_update_aws_cli_mac() (
  echo_gray "installing/updating aws cli..."
  dir=$(mktemp -d)
  trap 'rm -rf "$dir"' EXIT
  cd "$dir" || exit 1
  local url filename
  filename="AWSCLIV2.pkg"
  url="https://awscli.amazonaws.com/$filename"
  curl -sS "$url" -o "$filename"
  sudo installer -pkg "$filename" -target /
)

install_or_update_aws_sam_cli_linux() (
  echo_gray "installing/updating aws sam cli..."
  dir=$(mktemp -d)
  trap 'rm -rf "$dir"' EXIT
  cd "$dir" || exit 1
  local url filename dir_name
  dir_name="sam-installation"
  filename="aws-sam-cli-linux-x86_64.zip"
  url="https://github.com/aws/aws-sam-cli/releases/latest/download/$filename"
  curl -sSL "$url" -o "$filename"
  unzip -q "$filename" -d "$dir_name"
  sudo ./$dir_name/install --update
)

install_or_update_aws_sam_cli_mac() (
  echo_gray "installing/updating aws sam cli..."
  dir=$(mktemp -d)
  trap 'rm -rf "$dir"' EXIT
  cd "$dir" || exit 1
  local arch url filename dir_name
  arch=$(uname -m)
  dir_name="sam-installation"
  filename="aws-sam-cli-macos-arm64.zip"
  [[ "$arch" != "arm64" ]] && filename="aws-sam-cli-macos-x86_64.zip"
  url="https://github.com/aws/aws-sam-cli/releases/latest/download/$filename"
  curl -sSL "$url" -o "$filename"
  unzip -q "$filename" -d "$dir_name"
  sudo ./$dir_name/install --update
)

install_gtk_theme() (
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

# WARN: only linux
install_devpod() (
  echo_gray "installing/updating devpod..."
  dir=$(mktemp -d)
  trap 'rm -rf "$dir"' EXIT
  cd "$dir" || exit 1
  local url
  url="https://github.com/loft-sh/devpod/releases/latest/download/devpod-linux-amd64"
  curl -sSL "$url" -o devpod &&
    sudo install -c -m 0755 devpod /usr/local/bin
)

setup_zsh_as_default() {
  if [[ "$(realpath "$SHELL")" != "$(which zsh)" ]]; then
    echo_amber "changing default shell to zsh..."
    sudo chsh -s "$(which zsh)" "$USER"
  fi
}

add_user_to_docker_group() {
  # Add user to docker group for running docker without sudo
  sudo usermod -aG docker "$USER"
}

build_bat_cache() {
  # Rebuild bat cache for syntax highlighting
  bat cache --build &>/dev/null
}

fix_btop_graphics() {
  # Fix btop Intel graphics issue (set performance monitoring capability)
  sudo setcap cap_perfmon=+ep "$(which btop)"
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

pre_config_generic() {
  create_cache_dir
  create_config_dir
  setup_terraform_plugin_cache
  link_home "gitconfig" ".gitconfig"
}

post_config_generic() {
  setup_zsh_as_default
  link_bin_dir
  link_home "vim" ".vim"
  link_home "vimrc" ".vimrc"
  link_config "nvim"
  link_config "eza"
  link_config "lazydocker"
  link_config "lazygit"
  link_config "starship"
  link_config "kitty"
  link_alacritty
  link_ghostty
  link_config "bat"
  build_bat_cache
  setup_tmux
}

post_config_linux() {
  post_config_generic

  add_user_to_docker_group
  fix_btop_graphics
  link_config "btop"
  link_config "k9s"
  link_config "gtk-3.0"
  link_config "gtk-4.0"
  link_config "qt5ct"
  link_config "qt6ct"
  enable_service "docker"
  setup_user_service "wl-paste.service"
}

usage() {
  echo "Usage: $0 [update|config|full]"
  echo "  update  - Update packages only"
  echo "  config  - Apply configuration only"
  echo "  full    - Full install (default)"
}

set_run_mode() {
  case "${1:-}" in
  update)
    RUN_MODE="update"
    ;;
  config)
    RUN_MODE="config"
    ;;
  full)
    RUN_MODE="full"
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  "")
    usage
    exit 1
    ;;
  *)
    echo_red "Unknown option: $1"
    usage
    exit 1
    ;;
  esac
}

should_update() { [[ "$RUN_MODE" == "update" ]]; }
should_config() { [[ "$RUN_MODE" == "config" ]]; }
should_full() { [[ "$RUN_MODE" == "full" ]]; }
