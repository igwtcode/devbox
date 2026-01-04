#!/usr/bin/env zsh

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
  # exec Hyprland
  exec start-hyprland
fi
