#!/usr/bin/env bash

set -euo pipefail
source ./lib.sh || source "$(dirname "$0")/lib.sh"

usage() {
  echo "Usage: $0 [update|config|full]"
  echo "  update  - Update packages only"
  echo "  config  - Apply configuration only"
  echo "  full    - Full install (default)"
  exit 1
}

do_update() {
  init
  prepare_os
  install_packages
  install_or_update_rust
  install_or_update_aws_cli
  install_or_update_aws_sam_cli
}

do_config() {
  init
  config_tools
  config_services
}

do_full() {
  do_update
  config_tools
  config_services
}

case "${1:-full}" in
update)
  do_update
  ;;
config)
  do_config
  ;;
full)
  do_full
  ;;
-h | --help)
  usage
  ;;
*)
  echo_red "Unknown option: $1"
  usage
  ;;
esac

echo_green "setup complete!"
