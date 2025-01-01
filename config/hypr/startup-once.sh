#!/usr/bin/env bash
# vim: ft=sh

# Kill existing instances of required services
killall -q \
  hyprpaper \
  waybar \
  hypridle \
  dunst \
  polkit-gnome-authentication-agent \
  xdg-desktop-portal-wlr \
  xdg-desktop-portal

# Update environment variables for dbus
dbus-update-activation-environment --systemd --all

# Start necessary services
waybar &
hypridle &
hyprpaper &
dunst &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xdg-desktop-portal-wlr &
sleep 1
/usr/lib/xdg-desktop-portal &
wl-paste --watch cliphist store &

sleep 2

hyprctl dispatch workspace 1 && (ghostty &)
sleep 1

hyprctl dispatch workspace 2 && (1password &)
sleep 3

hyprctl dispatch workspace 4 && (firefox &)
sleep 2

hyprctl dispatch workspace 6 && (ghostty -e zsh -c 'tmux' &)
sleep 2

hyprctl dispatch workspace 7 && (firefox &)
sleep 2

hyprctl dispatch workspace 6
