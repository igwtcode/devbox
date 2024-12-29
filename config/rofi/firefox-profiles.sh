#!/usr/bin/env bash
# vim: ft=bash

PROFILES_DIR="$HOME/.mozilla/firefox"
PROFILE_PREFIX="csm-pfe-pfx."
NT_TITLE="FireFox Profiles"

# Function to prepend the prefix to the profile name if not already present
prepend_prefix() {
  local name="$1"
  [[ "$name" != "$PROFILE_PREFIX"* ]] && name="${PROFILE_PREFIX}${name}"
  echo "$name"
}

# Function to remove the prefix from a profile name for display purposes
remove_prefix() {
  local name="$1"
  name="${name#$PROFILE_PREFIX}"
  echo "$name"
}

# Function to list profiles starting with the prefix and show clean names to the user
list_profiles() {
  local profiles=()
  for dir in "$PROFILES_DIR"/"$PROFILE_PREFIX"*; do
    [[ -d "$dir" ]] && profiles+=("$(remove_prefix "$(basename "$dir")")")
  done

  # Calculate the number of items
  local num_profiles=${#profiles[@]}

  local conf=~/.config/rofi/firefox-profiles.rasi
  # Display profiles using rofi with custom width and dynamic height
  printf "%s\n" "${profiles[@]}" | rofi -dmenu -i -l $num_profiles -config $conf
}

# Function to create a new profile directory
create_profile() {
  local profile_name
  profile_name=$(prepend_prefix "$1")
  local profile_path="$PROFILES_DIR/$profile_name"

  if mkdir -p "$profile_path"; then
    notify-send -u normal $NT_TITLE "Profile '$1' created at $profile_path."
  else
    notify-send -u critical $NT_TITLE "Failed to create profile '$1' at $profile_path."
    exit 1
  fi
}

# Function to open a profile
open_profile() {
  local profile_name
  profile_name=$(prepend_prefix "$1")
  local profile_dir="$PROFILES_DIR/$profile_name"

  if [[ -d "$profile_dir" ]]; then
    # firefox -no-remote -profile "$profile_dir"
    firefox -profile "$profile_dir"
  else
    # Ask for confirmation using rofi
    local conf=~/.config/rofi/confirmation.rasi
    local confirmation=$(echo -e "No\nYes" | rofi -dmenu -i -mesg "Profile '$1' not found! Create it?" -config $conf)
    if [[ "$confirmation" == "Yes" ]]; then
      create_profile "$1"
      firefox -no-remote -profile "$profile_dir"
    else
      notify-send -u normal $NT_TITLE "Profile creation for '$1' was canceled."
      exit 1
    fi
  fi
}

# Main script logic
if [[ "$#" -eq 0 ]]; then
  selected_profile=$(list_profiles)
  [[ -n "$selected_profile" ]] && open_profile "$selected_profile"
elif [[ "$#" -eq 1 ]]; then
  open_profile "$1"
else
  notify-send -u critical $NT_TITLE "Invalid usage. Provide zero or one argument."
  exit 1
fi
