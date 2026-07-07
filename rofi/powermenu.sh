#!/usr/bin/env bash

options="  Shutdown\n  Reboot\n󰍃  Logout\n  Suspend\n  Hibernate\n  Lock"

chosen=$(echo -e "$options" | rofi -show-icons false -dmenu -p "Power:" -theme-str 'entry { placeholder: ""; }')

case "$chosen" in
"  Shutdown")
  systemctl poweroff
  ;;
"  Reboot")
  systemctl reboot
  ;;
"  Suspend")
  systemctl suspend
  ;;
"  Hibernate")
  systemctl hibernate
  ;;
"  Logout")
  i3-msg exit || hyprctl dispatch exit || bspc quit
  ;;
"  Lock")
  i3lock -c 000000
  ;;
esac
