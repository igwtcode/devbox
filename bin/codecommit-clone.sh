#!/usr/bin/env bash
# vim: ft=bash

# (hint) on mac: deactivate osxkeychain for credentials
# find system config path: git config -l --show-origin | grep credential
# git config --system --unset credential.helper
# /opt/homebrew/etc/gitconfig

SCRIPT_DIR=$(dirname "$(realpath "$0")")
source ./_lib.sh 2>/dev/null || source "$SCRIPT_DIR/_lib.sh"

[[ "$(get_os)" == "mac" ]] && { git config --system --unset credential.helper; }

echo_gray "getting git username and email..."
op_git=$(op item get git-codecommit --format json --fields label=email,username)
GIT_USER_NAME=$(echo "$op_git" | jq -r '.[] | select(.label == "username") | .value')
GIT_EMAIL=$(echo "$op_git" | jq -r '.[] | select(.label == "email") | .value')
[[ ! -n "$GIT_USER_NAME" || ! -n "$GIT_EMAIL" ]] && { echo_red "git username and email not found" && exit 1; }
echo_blue "username: $GIT_USER_NAME, email: $GIT_EMAIL"

# GIT_USER_NAME="$CUSTOM_HOSTNAME"
# if [ ! -n "$GIT_USER_NAME" ]; then
#   read -p "enter a name for gitconfig user.name: " GIT_USER_NAME
# fi
# if [[ -z "$GIT_USER_NAME" || ! "$GIT_USER_NAME" =~ ^[a-zA-Z0-9_+-]+$ ]]; then
#   echo_red "gitconfig user.name is required and must be one word with only alphanumeric characters, '-', '_', or '+'"
#   exit 1
# fi

AWS_PROFILE=$(get_aws_profile)

if [ ! -n "$AWS_PROFILE" ]; then
  echo_red "no aws profile selected"
  exit 2
fi

AWS_REGION=$(aws configure get region --profile "$AWS_PROFILE")
GIT_CRED_HELPER="!aws --profile \"$AWS_PROFILE\" codecommit credential-helper \$@"
BASE_DIR="$CODEBOX_DIR/$(echo "$AWS_PROFILE" | awk -F'@' '{print $NF}')"

REPO_NAMES=($(aws codecommit list-repositories --profile "$AWS_PROFILE" --output json | jq -r '.repositories[].repositoryName'))
TOTAL_COUNT=${#REPO_NAMES[@]}

git config --global credential.helper "$GIT_CRED_HELPER"
git config --global credential.UseHttpPath true

counter=0
for name in "${REPO_NAMES[@]}"; do
  counter=$((counter + 1))
  dir="$BASE_DIR/$name"
  url="https://git-codecommit.$AWS_REGION.amazonaws.com/v1/repos/$name"
  percent=$((counter * 100 / TOTAL_COUNT))
  pretty_dir=$(echo "$dir" | sed "s|$HOME|~|g")
  echo_msg="*** [$counter/$TOTAL_COUNT] ($percent%) $pretty_dir"

  if [ -d "$dir" ]; then
    echo_cyan "$echo_msg"
  else
    echo_amber "$echo_msg"
    git clone "$url" "$dir" &&
      (
        cd "$dir" &&
          git config --local credential.helper "$GIT_CRED_HELPER" &&
          git config --local credential.UseHttpPath true &&
          git config --local user.name "$GIT_USER_NAME" &&
          git config --local user.email "$GIT_EMAIL"
      )
    # cd $BASE_DIR
  fi
done

git config --global --unset credential.helper
git config --global --unset credential.UseHttpPath
