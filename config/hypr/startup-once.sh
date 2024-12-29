#!/usr/bin/env bash
# vim: set filetype=bash:

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
