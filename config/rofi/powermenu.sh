#!/usr/bin/env bash
# vim: ft=bash

conf=~/.config/rofi/powermenu.rasi
options="  Lock\n󰤄  Suspend\n󰒲  Hibernate\n󰜉  Reboot\n  Shutdown\n󰗽  Logout"

selected_option=$(echo -e "$options" | rofi -dmenu -i -config $conf)
selected_option=$(echo $selected_option | cut -d " " -f 2)

case $selected_option in
  Lock)
    hyprlock
    ;;
  Suspend)
    pkexec systemctl suspend
    ;;
  Hibernate)
    pkexec systemctl hibernate
    ;;
  Reboot)
    pkexec systemctl reboot
    ;;
  Shutdown)
    pkexec systemctl poweroff
    ;;
  Logout)
    # TODO: Check this
    hyprctl dispatch exit
    ;;
  *)
    exit 1
    ;;
esac
