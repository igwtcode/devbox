#!/usr/bin/env bash
# vim: ft=bash

cliphist list |
  rofi \
    -dmenu \
    -matching-negate-char '\0' \
    -display-columns 2 \
    -p ' ' \
    -config ~/.config/rofi/cliphist.rasi |
  cliphist decode | wl-copy
