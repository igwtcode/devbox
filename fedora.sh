#!/usr/bin/env bash

set -euo pipefail
source ./_common.sh
source ./_brew.sh

OS_ALIAS="fedora"

update_dnf() {
  sudo dnf upgrade -y
}
