#!/usr/bin/env bash
# vim: ft=bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
source ./_lib.sh 2>/dev/null || source "$SCRIPT_DIR/_lib.sh"

CODEBOX_DIR="$HOME/codebox/igwtcode"
ZIP_NAME="codebox-igwtcode-envfiles.zip"
TMP_ZIP="/tmp/$ZIP_NAME"
OP_DOC_TITLE="~/$ZIP_NAME"

# Find all .env files in ~/codebox using fd
find_env_files() {
  fd -H -I -t f '^\.env($|\.)' "$CODEBOX_DIR" -E node_modules | sort
}

save_envfiles() {
  echo_gray "finding .env files in $CODEBOX_DIR..."

  env_files=$(find_env_files)
  if [[ -z "$env_files" ]]; then
    echo_red "no .env files found" && exit 1
  fi

  echo_gray "found $(echo "$env_files" | wc -l | tr -d ' ') .env files:"
  echo "$env_files" | sed "s|$HOME|~|g"

  # Create zip with paths relative to home
  echo_gray "creating zip..."
  rm -f "$TMP_ZIP"

  (
    cd "$HOME" || exit 1
    echo "$env_files" | sed "s|$HOME/||" | xargs zip -9 "$TMP_ZIP"
  )

  if [[ ! -f "$TMP_ZIP" ]]; then
    echo_red "failed to create zip" && exit 1
  fi

  # Check if document exists in 1Password
  echo_gray "checking 1Password..."
  doc_id=$(op document list --format json | jq -r '.[] | select(.title == "'"$OP_DOC_TITLE"'") | .id')

  if [[ -n "$doc_id" ]]; then
    echo_gray "updating existing document $doc_id..."
    op document edit "$doc_id" "$TMP_ZIP" && echo_green "saved $OP_DOC_TITLE"
  else
    echo_gray "creating new document..."
    op document create "$TMP_ZIP" --title "$OP_DOC_TITLE" && echo_green "created $OP_DOC_TITLE"
  fi

  rm -f "$TMP_ZIP"
}

load_envfiles() {
  echo_gray "checking 1Password..."
  doc_id=$(op document list --format json | jq -r '.[] | select(.title == "'"$OP_DOC_TITLE"'") | .id')

  if [[ -z "$doc_id" ]]; then
    echo_red "document $OP_DOC_TITLE not found in 1Password" && exit 1
  fi

  echo_gray "downloading $OP_DOC_TITLE..."
  op document get "$doc_id" --out-file "$TMP_ZIP"

  if [[ ! -f "$TMP_ZIP" ]]; then
    echo_red "failed to download zip" && exit 1
  fi

  echo_gray "extracting .env files to original paths..."
  unzip -o "$TMP_ZIP" -d "$HOME"

  echo_green "loaded .env files from $OP_DOC_TITLE"
  rm -f "$TMP_ZIP"
}

# Main
selected_opt=$(echo -e "save\nload" | fzf --prompt="env files: ")
if [[ -z "$selected_opt" ]]; then
  echo_red "no option selected" && exit 1
fi

case "$selected_opt" in
save) save_envfiles ;;
load) load_envfiles ;;
esac
