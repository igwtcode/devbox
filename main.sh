#!/usr/bin/env bash
# vim: ft=bash

CONFIG_DIR=$(pwd)/config
DOTCONFIG_DIR=$HOME/.config

echo_gray() {
  echo -e "\033[90m$1\033[0m" # Gray/Dim
}
echo_amber() {
  echo -e "\033[33m$1\033[0m" # Yellow/Amber
}
echo_red() {
  echo -e "\033[31m$1\033[0m" # Red
}
echo_green() {
  echo -e "\033[32m$1\033[0m" # Green
}
echo_blue() {
  echo -e "\033[34m$1\033[0m" # Blue
}
echo_cyan() {
  echo -e "\033[36m$1\033[0m" # Cyan
}
echo_magenta() {
  echo -e "\033[35m$1\033[0m" # Magenta
}

# DOS = (mac, archlinux or al2023)
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    DOS="mac"
  elif [[ -f /etc/os-release ]]; then
    local os_id=$(grep ^ID= /etc/os-release | cut -d'=' -f2 | tr -d '"')
    case "$os_id" in
    arch)
      DOS="archlinux"
      ;;
    amzn)
      DOS="al2023"
      ;;
    *)
      echo_red "unsupported os: $os_id" && exit 1
      ;;
    esac
  else
    echo "unknown os" && exit 1
  fi
  echo_green "detected os: $DOS"
}

pre_install() {
  mkdir -p "$DOTCONFIG_DIR"
  mkdir -p "$HOME/.terraform.d/plugin-cache"

  ln -sfn "$CONFIG_DIR/gitconfig" "$HOME/.gitconfig"

  if [[ "$DOS" == "mac" || "$DOS" == "al2023" ]]; then
    echo_gray "checking for homebrew..."
    if ! command -v brew &>/dev/null; then
      echo_gray "installing homebrew..."
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo_gray "update, upgrade and cleanup homebrew..."
    brew update && brew upgrade && brew cleanup
  fi

  if [[ "$DOS" == "archlinux" ]]; then
    echo_gray "setting timezone to Europe/Berlin..."
    sudo ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
    sudo hwclock --systohc

    echo_gray "initializing pacman keys and updating..."
    sudo pacman-key --init
    sudo pacman-key --populate archlinux
    sudo pacman -Sy --needed --noconfirm archlinux-keyring && sudo pacman -Su --noconfirm
    sudo pacman -Sc --noconfirm

    echo_gray "checking for yay config..."
    if [ ! -d "$DOTCONFIG_DIR/yay" ]; then
      echo_amber "yay config not found, copying..."
      cp -r "$CONFIG_DIR/yay" "$DOTCONFIG_DIR/yay"
    fi

    local yay_dir="/opt/yay"
    echo_gray "checking for yay..."
    if ! command -v yay &>/dev/null; then
      echo_amber "yay not found, installing..."
      sudo mkdir -p "$yay_dir"
      sudo chown -R "$USER":"$USER" "$yay_dir"
      git clone https://aur.archlinux.org/yay.git "$yay_dir"
      cd "$yay_dir" || { echo_red "yay directory not found" && exit 1; }
      makepkg -si --noconfirm
      yay -Y --gendb --noconfirm && yay -Syu --noconfirm
      # yay -Y --gendb --noconfirm && yay -Syu --devel --noconfirm
      cd - || { echo_red "failed to change directory" && exit 1; }
    fi
    echo_gray "update, upgrade and cleanup yay..."
    yay -Syyu --noconfirm && yay -Yc --noconfirm

  fi
}

install() {
  local pkg_file="$(pwd)/pkg/$DOS.txt"
  [[ -f "$pkg_file" ]] || { echo_red "package file not found: $pkg_file" && exit 1; }

  echo_gray "reading packages from $pkg_file..."
  local items=()
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Trim leading/trailing whitespace
    svc=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    # Skip empty lines or lines starting with '#' or ';'
    if [[ -z "$svc" || "$svc" == \#* || "$svc" == \;* ]]; then
      continue
    fi

    items+=("$svc")
  done <"$pkg_file"

  if [ ${#items[@]} -gt 0 ]; then
    if [[ "$DOS" == "mac" || "$DOS" == "al2023" ]]; then
      echo_gray "checking ${#items[@]} homebrew packages..."
      printf "%s\n" "${items[@]}" | xargs brew install -q
    elif [[ "$DOS" == "archlinux" ]]; then
      echo_gray "checking ${#items[@]} yay packages..."
      yay -S --needed --noconfirm "${items[@]}"

      echo_gray "installing ms teams with flatpak..."
      flatpak install -y com.github.IsmaelMartinez.teams_for_linux
    fi
  fi

  echo_gray "installing rust with rustup..."
  rustup default stable
  rustup update
}

post_install() {
  ln -sfn "$(pwd)/bin" "$HOME/bin"

  ln -sfn "$CONFIG_DIR/prettierrc" "$HOME/prettierrc"
  ln -sfn "$CONFIG_DIR/terraformrc" "$HOME/.terraformrc"

  ln -sfn "$CONFIG_DIR/vim" "$HOME/.vim"
  ln -sfn "$CONFIG_DIR/vimrc" "$HOME/.vimrc"
  ln -sfn "$CONFIG_DIR/nvim" "$DOTCONFIG_DIR/nvim"

  ln -sfn "$CONFIG_DIR/bat" "$DOTCONFIG_DIR/bat"
  # Rebuild bat cache for syntax highlighting
  bat cache --build &>/dev/null

  ln -sfn "$CONFIG_DIR/lazydocker" "$DOTCONFIG_DIR/lazydocker"
  ln -sfn "$CONFIG_DIR/lazygit" "$DOTCONFIG_DIR/lazygit"

  ln -sfn "$CONFIG_DIR/starship" "$DOTCONFIG_DIR/starship"

  ln -sfn "$CONFIG_DIR/bashrc" "$HOME/.bashrc"
  ln -sfn "$CONFIG_DIR/zshrc" "$HOME/.zshrc"

  if [[ "$(realpath "$SHELL")" != "$(which zsh)" ]]; then
    echo_amber "changing default shell to zsh..."
    sudo chsh -s "$(which zsh)" "$USER"
  fi

  ln -sfn "$CONFIG_DIR/yazi" "$DOTCONFIG_DIR/yazi"
  # Install Yazi flavor for Catppuccin Mocha theme
  # ya pack -a yazi-rs/flavors:catppuccin-mocha &>/dev/null

  ln -sfn "$CONFIG_DIR/tmux" "$DOTCONFIG_DIR/tmux"
  local tmux_tpm="$DOTCONFIG_DIR/tmux/plugins/tpm"
  [[ -d "$tmux_tpm" ]] || { git clone https://github.com/tmux-plugins/tpm "$tmux_tpm" && $tmux_tpm/bin/install_plugins; }

  if [[ "$DOS" == "mac" || "$DOS" == "archlinux" ]]; then
    ln -sfn "$CONFIG_DIR/alacritty/$DOS.toml" "$CONFIG_DIR/alacritty/alacritty.toml"
    ln -sfn "$CONFIG_DIR/alacritty" "$DOTCONFIG_DIR/alacritty"

    ln -sfn "$CONFIG_DIR/kitty" "$DOTCONFIG_DIR/kitty"

    ln -sfn "$CONFIG_DIR/ghostty/$DOS" "$CONFIG_DIR/ghostty/config"
    ln -sfn "$CONFIG_DIR/ghostty" "$DOTCONFIG_DIR/ghostty"

    ln -sfn "$CONFIG_DIR/wallpaper" "$DOTCONFIG_DIR/wallpaper"
  fi

  if [[ "$DOS" == "mac" ]]; then
    ln -sfn "$CONFIG_DIR/wezterm" "$DOTCONFIG_DIR/wezterm"
  fi

  if [[ "$DOS" == "archlinux" ]]; then
    ln -sfn "$CONFIG_DIR/btop" "$DOTCONFIG_DIR/btop"
    # Fix btop Intel graphics issue (set performance monitoring capability)
    sudo setcap cap_perfmon=+ep "$(which btop)"

    ln -sfn "$CONFIG_DIR/code-flags.conf" "$DOTCONFIG_DIR/code-flags.conf"
    ln -sfn "$CONFIG_DIR/dunst" "$DOTCONFIG_DIR/dunst"
    ln -sfn "$CONFIG_DIR/hypr" "$DOTCONFIG_DIR/hypr"
    ln -sfn "$CONFIG_DIR/rofi" "$DOTCONFIG_DIR/rofi"
    ln -sfn "$CONFIG_DIR/waybar" "$DOTCONFIG_DIR/waybar"
  fi

  if [[ "$DOS" == "al2023" || "$DOS" == "archlinux" ]]; then
    # Add user to docker group for running docker without sudo
    sudo usermod -aG docker "$USER"

    local services=("docker" "sshd")

    if [[ "$DOS" == "archlinux" ]]; then
      services+=(
        "acpid"
        "bluetooth"
        "fstrim.timer"
        "NetworkManager"
        # "avahi-daemon"
      )
    fi

    # Enable and start necessary services
    for svc in "${services[@]}"; do
      echo_gray "enabling and starting service: $svc"
      sudo systemctl enable --now "$svc" || { echo_red "failed to enable/start service: $svc" >&2; }
    done
  fi
}

main() {
  detect_os
  pre_install
  install
  post_install
}

main
