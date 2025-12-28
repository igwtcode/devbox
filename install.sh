#!/usr/bin/env bash

set -euo pipefail
source ./lib.sh || source "$(dirname "$0")/lib.sh"

init
prepare_os

install_packages
install_or_update_rust
install_or_update_aws_cli
install_or_update_aws_sam_cli

config_tools

setup_services
setup_libvirt
setup_user_services

echo_green "setup complete!"
