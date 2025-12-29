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

brew_install_pkg() {
  local -n items=$1 # nameref to caller's array
  [[ ${#items[@]} == 0 ]] && return
  printf "%s\n" "${items[@]}" | xargs brew install -q
}
