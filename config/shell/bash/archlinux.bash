#!/usr/bin/env bash
# vim: ft=bash

# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

source $HOME/.config/shell/bash/common.bash

source /usr/share/nvm/init-nvm.sh

alias cp-awsprofile="sel-awsprofile | tr -d '\n' | wl-copy"

# if [[ -n "$WAYLAND_DISPLAY" || -n "$DISPLAY" ]]; then
# fi
