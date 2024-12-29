#!/usr/bin/env bash
# vim: ft=bash

# create AppleScript shortcuts for each chrome profile on macOS
setup_chrome_profiles_shortcut() {
  # Directory to store the AppleScript files
  local applescript_dir="$HOME/Documents/chrome-profiles"
  # Clean up old profiles
  if [ -d "$applescript_dir" ]; then
    rm -r "$applescript_dir"
  fi
  # Create the directory
  mkdir -p "$applescript_dir"
  # Loop over each profile directory
  cd ~/Library/Application\ Support/Google/Chrome
  for d in *Profile*; do
    profile_name=$(jq -r .profile.name "$d/Preferences" | tr -d ' ')
    if [ "$profile_name" != "null" ] && [ "$profile_name" != "Guest" ] && [ "$profile_name" != "SystemProfile" ] && [ "$profile_name" != "Person1" ]; then
      echo "Creating AppleScript for profile: $profile_name"
      # Create the AppleScript file
      applescript_path="$applescript_dir/$profile_name.applescript"
      echo "do shell script \"open -na 'Google Chrome' --args --profile-directory='$d'\"" >"$applescript_path"
      # Convert the AppleScript file to an app
      osacompile -o "$applescript_dir/$profile_name.app" "$applescript_path"
      # Remove the AppleScript file
      rm "$applescript_path"
    fi
  done
  cd -
}

setup_chrome_profiles_shortcut
