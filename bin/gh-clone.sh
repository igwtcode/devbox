#!/usr/bin/env bash
# vim: ft=bash

# requirements: gh cli (https://cli.github.com/)
# - run `gh auth login` to authenticate with github before running this script
# - run `gh auth setup-git` to setup git config credential helper for github

SCRIPT_DIR=$(dirname "$(realpath "$0")")
source ./_lib.sh 2>/dev/null || source "$SCRIPT_DIR/_lib.sh"

GH_USER=$(gh api user)
USER_NAME=$(echo $GH_USER | jq -r '.name')
USER_ID=$(echo $GH_USER | jq -r '.id')
USER_LOGIN=$(echo $GH_USER | jq -r '.login')
USER_EMAIL="$USER_ID+$USER_LOGIN@users.noreply.github.com"

echo_gray "building repos list for $USER_LOGIN ..."

REPO_NAMES=($(gh repo list --limit 1000 --json nameWithOwner --jq '.[].nameWithOwner'))
ORG_NAMES=($(gh api user/memberships/orgs --jq '.[].organization.login'))
for org in "${ORG_NAMES[@]}"; do
  org_repo_names=($(gh repo list "$org" --limit 1000 --json nameWithOwner --jq '.[].nameWithOwner'))
  REPO_NAMES+=("${org_repo_names[@]}")
done

TOTAL_COUNT=${#REPO_NAMES[@]}
counter=0

for name in "${REPO_NAMES[@]}"; do
  counter=$((counter + 1))
  dir="$CODEBOX_DIR/$name"
  percent=$((counter * 100 / TOTAL_COUNT))
  pretty_dir=$(echo "$dir" | sed "s|$HOME|~|g")
  echo_msg="*** [$counter/$TOTAL_COUNT] ($percent%) $pretty_dir"

  if [ -d "$dir" ]; then
    echo_cyan "$echo_msg"
  else
    echo_amber "$echo_msg"
    gh repo clone "$name" "$dir" &&
      cd "$dir" &&
      git config --local user.name "$USER_NAME" &&
      git config --local user.email "$USER_EMAIL"
    cd $CODEBOX_DIR
  fi
done
