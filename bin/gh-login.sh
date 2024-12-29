#!/usr/bin/env bash
# vim: ft=bash

# requirements: gh cli (https://cli.github.com/)

SCRIPT_DIR=$(dirname "$(realpath "$0")")
source ./_lib.sh 2>/dev/null || source "$SCRIPT_DIR/_lib.sh"

echo_gray "listing github items..."
items=$(op item list --tags github --format json | jq -r '.[] | "\(.id)\t\(.title)\t\(.vault.name)"')
if [[ -z "$items" ]]; then
  echo_red "no github items found" && exit 1
fi

selected_items=$(echo "$items" | fzf --multi)
if [[ -z "$selected_items" ]]; then
  echo_red "no item selected" && exit 1
fi

while IFS= read -r item; do
  echo_gray "*** $(sed 's|\t| - |g' <<<"$item")"

  id=$(echo "$item" | cut -f1)
  name=$(echo "$item" | cut -f2)

  echo_blue "$name: getting token..."
  token=$(op item get "$id" --fields label="gh-token" --reveal)
  if [[ -z "$token" ]]; then
    echo_red "$name: no github token found" && continue
  fi

  echo_amber "$name: gh login..."
  echo "$token" | gh auth login --git-protocol https --hostname 'github.com' --skip-ssh-key --with-token
  echo_green "$name: done"
done <<<"$selected_items"
