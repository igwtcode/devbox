#!/usr/bin/env bash
# vim: ft=bash

# list all chrome profiles on macOS
list_chrome_profiles() {
  cd ~/Library/Application\ Support/Google/Chrome
  for d in *Profile*; do
    echo -n "$d: "
    jq -r .profile.name "$d/Preferences"
  done
  cd -
}

list_chrome_profiles
