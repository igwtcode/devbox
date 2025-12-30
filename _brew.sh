#!/usr/bin/env bash

IS_BREW_IN_PATH=""

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
  # Run in subshell with pipefail disabled to avoid SIGPIPE issues from installer
  (
    set +o pipefail
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  )
  add_brew_path_to_session
}

update_brew() {
  echo_gray "updating homebrew packages..."
  add_brew_path_to_session
  brew update
  brew upgrade
  brew cleanup
}

brew_install_pkg() {
  local items=()
  read_package_file_to_array "$1" items
  [[ ${#items[@]} == 0 ]] && return
  echo_gray "found ${#items[@]} brew packages to install"
  brew install -q "${items[@]}"
}
