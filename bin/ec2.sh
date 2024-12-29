#!/usr/bin/env bash
# vim: ft=bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
source ./_lib.sh 2>/dev/null || source "$SCRIPT_DIR/_lib.sh"

AWS_PROFILE=$(get_aws_profile)

if [ ! -n "$AWS_PROFILE" ]; then
  echo_red "no aws profile selected"
  exit 1
fi

AWS_REGION=$(aws configure get region --profile "$AWS_PROFILE")

instance_list_data=$(aws ec2 describe-instances \
  --profile "$AWS_PROFILE" \
  --region "$AWS_REGION" \
  --query 'Reservations[*].Instances[*].[InstanceId, State.Name, Tags[?Key==`Name`].Value | [0]]' \
  --output text | awk '{printf "%-21s %-12s %s\n", $1, $2, $3}')

if [ -z "$instance_list_data" ]; then
  echo_amber "no instance found"
  exit 0
fi

instance=$(echo "$instance_list_data" | fzf)

if [ -z "$instance" ]; then
  echo_red "no instance selected"
  exit 1
fi

instance_id=$(echo "$instance" | awk '{print $1}')
instance_state=$(echo "$instance" | awk '{print $2}')
instance_name=$(echo "$instance" | awk '{print $3}')

if [ "$instance_state" == "running" ]; then
  action="stop"
else
  action="start"
fi

confirm_prompt="$action '$instance_name' (currently '$instance_state')? (y/n) "
read -p "$confirm_prompt" confirmation
if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
  echo_cyan "action canceled"
  exit 0
fi

aws ec2 "$action-instances" \
  --instance-ids "$instance_id" \
  --profile "$AWS_PROFILE" \
  --region "$AWS_REGION" \
  --output json | jq
