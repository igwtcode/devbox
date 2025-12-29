#!/usr/bin/env bash

set -euo pipefail
source ./_common.sh
source ./_brew.sh

OS_ALIAS="ubuntu"

update_apt() {
  sudo apt update
  sudo apt full-upgrade -y
  sudo apt autoremove -y
  sudo apt autoclean -y
}
