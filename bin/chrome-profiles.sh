#!/usr/bin/env bash
# vim: ft=bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
source ./_lib.sh 2>/dev/null || source "$SCRIPT_DIR/_lib.sh"

[[ "$(get_os)" != "mac" ]] && {
  echo_red "this script is for macOS only"
  exit 1
}

dir=$(pwd)
trap 'cd "$dir"' EXIT

chrome_dir=~/Library/Application\ Support/Google/Chrome

list_chrome_profiles() {
  echo_gray "listing all chrome profiles..."
  cd "$chrome_dir" || { echo "chrome directory not found" && exit 1; }

  for d in *Profile*; do
    if [[ -d "$d" ]]; then
      profile_name=$(jq -r .profile.name "$d/Preferences" 2>/dev/null)
      if [[ "$profile_name" != "null" && -n "$profile_name" ]]; then
        echo_cyan "$d: $profile_name"
      fi
    fi
  done
}

setup_chrome_profiles_shortcut() {
  echo_gray "creating applescript shortcuts for chrome profiles..."

  local applescript_dir="$HOME/Documents/chrome-profiles"
  [[ -d "$applescript_dir" ]] && { rm -rf "$applescript_dir"; }
  mkdir -p "$applescript_dir"
  cd "$chrome_dir" || { echo "chrome directory not found" && exit 1; }

  # Loop over each profile directory
  for d in *Profile*; do
    profile_name=$(jq -r .profile.name "$d/Preferences" | tr -d ' ')
    if [[ "$profile_name" != "null" && "$profile_name" != "Guest" && "$profile_name" != "SystemProfile" && "$profile_name" != "Person1" ]]; then
      echo_gray "creating applescript for profile: $profile_name"
      applescript_path="$applescript_dir/$profile_name.applescript"
      echo "do shell script \"open -na 'Google Chrome' --args --profile-directory='$d'\"" >"$applescript_path"
      # Convert the AppleScript file to an app
      osacompile -o "$applescript_dir/$profile_name.app" "$applescript_path"
      # Remove the AppleScript file
      rm "$applescript_path"
    fi
  done
}

main() {
  local option=$(printf "list\ncreate-shortcuts" | fzf)

  case "$option" in
  list)
    list_chrome_profiles
    ;;
  create-shortcuts)
    setup_chrome_profiles_shortcut
    ;;
  *)
    echo "no valid option selected" && exit 1
    ;;
  esac
}

main
