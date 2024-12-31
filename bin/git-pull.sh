#!/usr/bin/env bash
# vim: ft=bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
source ./_lib.sh 2>/dev/null || source "$SCRIPT_DIR/_lib.sh"

get_current_branch() { git branch --show-current 2>/dev/null; }

# Function to pull all branches in a git repository
git_pull_all_branches() {
  local current_branch="$1"

  git fetch origin

  # Get a list of all remote branches (stripped of the 'origin/' prefix)
  local remote_branches=$(git branch -r | grep -v HEAD | sed 's|origin/||')
  [[ -z "$remote_branches" ]] && return 0

  for branch in $remote_branches; do
    if ! git show-ref --verify --quiet refs/heads/$branch; then
      git branch --track "$branch" "origin/$branch"
    fi
    if ! git checkout "$branch" || ! git pull origin "$branch"; then
      echo_red "failed to checkout or pull branch: $branch"
      git switch "$current_branch"
      return 1
    fi
  done
  git switch "$current_branch"
}

# Function to loop through directories and pull branches for each git repository
process_directories() {
  local dirs=$(find . -maxdepth 1 -type d -not -path . | sed 's|^\./||' | fzf --multi)
  [[ -z "$dirs" ]] && { echo_red "no directories selected" && return 1; }

  for d in $dirs; do
    (
      cd "$d" || { echo_red "failed to enter directory: $d" && return 1; }
      echo_gray "----------------------------------------"
      echo_amber "*** $d"
      git_pull_all_branches "$(get_current_branch)" || { echo_red "failed to process git repository in $d" && return 1; }
    )
  done
}

cb=$(get_current_branch)
if [[ -z "$cb" ]]; then
  process_directories
else
  git_pull_all_branches "$cb"
fi
