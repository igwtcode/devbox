#!/usr/bin/env bash
# vim: ft=bash

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

# installs package managers
# homebrew on macos and archlinux
setup_package_manager() {
  if [[ "$DOS" == "mac" || "$DOS" == "archlinux" ]]; then
    echo_gray "checking for homebrew..."
    if ! command -v brew &>/dev/null; then
      echo_blue "installing homebrew..."
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      echo_green "homebrew installed"
    else
      echo_green "homebrew already installed"
    fi
  fi
}

# install packages from a text file (one package per line)
# file name: ./pkg/$DOS.txt
install_packages() {
  local pkg_file="$(pwd)/pkg/$DOS.txt"
  [ ! -f "$pkg_file" ] && echo_red "package file not found: $pkg_file" && exit 1

  echo_gray "reading packages from $pkg_file..."
  local items=()
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Trim leading/trailing whitespace
    item=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

    # Skip empty lines or lines starting with '#' or ';'
    if [[ -z "$item" || "$item" == \#* || "$item" == \;* ]]; then
      continue
    fi

    items+=("$item")
  done <"$pkg_file"

  if [ ${#items[@]} -gt 0 ]; then
    if [[ "$DOS" == "mac" || "$DOS" == "al2023" ]]; then
      echo_gray "checking ${#items[@]} homebrew packages..."
      printf "%s\n" "${items[@]}" | xargs brew install -q
      echo_green "homebrew packages installed"
    # elif [[ "$DOS" == "archlinux" ]]; then
    #   sudo pacman -S --noconfirm "${items[@]}"
    fi
  fi
}

# update, upgrade and cleanup (if applicable) packages
update_and_cleanup_packages() {
  if [[ "$DOS" == "mac" || "$DOS" == "al2023" ]]; then
    echo_gray "update, upgrade and cleanup homebrew..."
    brew update && brew upgrade && brew cleanup
    echo_green "homebrew updated"
  fi
}

main() {
  detect_os
  setup_package_manager
  install_packages
  update_and_cleanup_packages

  # echo "alias lzd='lazydocker'" >> ~/.zshrc
}

main
