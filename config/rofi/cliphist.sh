#!/usr/bin/env bash
# vim: ft=bash

conf=~/.config/rofi/cliphist.rasi
cliphist list | rofi -dmenu -i -display-columns 2 -config $conf | cliphist decode | wl-copy
