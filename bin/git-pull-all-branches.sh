#!/usr/bin/env bash
# vim: ft=bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
source ./_lib.sh 2>/dev/null || source "$SCRIPT_DIR/_lib.sh"

current_branch=$(git branch --show-current 2>/dev/null)

[ ! -n "$current_branch" ] && echo_red "not a git repository." && exit 1

trap 'git switch "$current_branch"' EXIT

git fetch origin

# Get a list of all remote branches (stripped of the 'origin/' prefix)
for branch in $(git branch -r | grep -v '\->' | sed 's/origin\///'); do
  if ! git show-ref --verify --quiet refs/heads/$branch; then
    git branch --track "$branch" "origin/$branch"
  fi
  if ! git checkout "$branch" || ! git pull origin "$branch"; then
    echo_red "failed to checkout or pull branch: $branch"
    exit 1
  fi
done
