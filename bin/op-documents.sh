#!/usr/bin/env bash
# vim: ft=bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
source ./_lib.sh 2>/dev/null || source "$SCRIPT_DIR/_lib.sh"

echo_gray "listing documents..."
documents=$(op documents list --format json | jq -r '.[] | select(.title | startswith("~/")) | "\(.id)\t\(.title)"')
if [[ -z "$documents" ]]; then
  echo_red "no documents found" && exit 1
fi

selected_documents=$(echo "$documents" | fzf --multi)
if [[ -z "$selected_documents" ]]; then
  echo_red "no document selected" && exit 1
fi

selected_opt=$(echo -e "save\nload" | fzf)
if [[ -z "$selected_opt" ]]; then
  echo_red "no option selected" && exit 1
fi

while IFS= read -r doc; do
  echo_gray "*** $(sed 's|\t| - |g' <<<"$doc")"

  id=$(echo "$doc" | cut -f1)
  name=$(echo "$doc" | cut -f2)
  path=$(echo "$name" | sed 's|~|'"$HOME"'|')

  if [[ "$selected_opt" == "save" ]]; then
    echo_gray "saving $name..."

    if [[ "$name" == *.zip ]]; then
      dir_path="${path%.zip}" # Remove .zip suffix to get the directory path
      if [[ -d "$dir_path" ]]; then
        echo_gray "zipping directory $dir_path to $path..."
        (
          cd "$(dirname "$dir_path")" || { echo_red "failed to cd to $(dirname "$dir_path")" && exit 1; }
          zip -r "$(basename "$path")" "$(basename "$dir_path")" -x "*.DS_Store" &&
            mv "$(basename "$path")" "$path" &&
            cd -
        ) &&
          echo_gray "saving $path..." &&
          op document edit "$id" "$path" &&
          echo_green "saved $name" &&
          rm -f "$path"
      else
        echo_red "directory $dir_path does not exist, skipping..." && continue
      fi
    else
      op document edit "$id" "$path" &&
        echo_green "saved $name"
    fi

  elif [[ "$selected_opt" == "load" ]]; then
    echo_gray "loading $name..."

    if [[ "$name" == *.zip ]]; then
      dir_path="${path%.zip}" # Remove .zip suffix to get the directory path
      op document get "$id" --out-file "$path" &&
        echo_gray "unzipping $path to $dir_path..." &&
        mkdir -p "$dir_path" &&
        unzip -o "$path" -d "$(dirname "$dir_path")" &&
        echo_green "loaded $name" &&
        rm -f "$path"
    else
      op document get "$id" --out-file "$path" &&
        echo_green "loaded $name"
    fi
  fi

done <<<"$selected_documents"
