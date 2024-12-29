#!/usr/bin/env bash
# vim: ft=bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
source ./_lib.sh 2>/dev/null || source "$SCRIPT_DIR/_lib.sh"

isgit=$(git branch --show-current 2>/dev/null)
[ -n "$isgit" ] || git-pull-all-branches.sh && exit 0

dir=$(pwd)

trap 'cd "$dir"' EXIT

for d in $(ls -1 | fzf --multi); do
  cd "$d" || exit 1
  echo_cyan "----------------------------------------"
  echo_amber "*** $1"
  git-pull-all-branches.sh
  cd "$dir" || exit 1
done
