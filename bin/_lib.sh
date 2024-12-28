# vim: ft=bash

CODEBOX_DIR="$HOME/codebox"

echo_gray() {
  echo -e "\033[90m$1\033[0m" # Gray/Dim
}
echo_amber() {
  echo -e "\033[33m$1\033[0m" # Yellow/Amber
}
echo_red() {
  echo -e "\033[31m$1\033[0m" # Red
}
echo_green() {
  echo -e "\033[32m$1\033[0m" # Green
}
echo_blue() {
  echo -e "\033[34m$1\033[0m" # Blue
}
echo_cyan() {
  echo -e "\033[36m$1\033[0m" # Cyan
}
echo_magenta() {
  echo -e "\033[35m$1\033[0m" # Magenta
}

get_aws_profile() {
  grep -E '^\[.+\]$' ~/.aws/credentials | sed -E 's/^\[(.+)\]$/\1/' | fzf
}
