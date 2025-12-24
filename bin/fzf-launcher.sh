#!/bin/bash

# Build list of "AppName|desktop-id" pairs
entries=$(grep -rL "NoDisplay=true" /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop 2>/dev/null |
  while read -r file; do
    name=$(grep -m1 "^Name=" "$file" 2>/dev/null | cut -d= -f2)
    id=$(basename "$file" .desktop)
    [ -n "$name" ] && echo "$name|$id"
  done | sort -u)

# Show names in fzf, get selection
selected=$(echo "$entries" | cut -d'|' -f1 | fzf --prompt=" Launch: ")

# Find the desktop id and launch
if [ -n "$selected" ]; then
  desktop_id=$(echo "$entries" | grep "^$selected|" | head -1 | cut -d'|' -f2)
  gtk-launch "$desktop_id" &>/dev/null &
fi
