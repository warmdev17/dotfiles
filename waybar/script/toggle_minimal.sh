#!/usr/bin/env bash

HOME_CONFIG="/home/warmdev/.config/waybar"
if pgrep -x waybar >/dev/null; then
  killall waybar
else
  waybar --config "$HOME_CONFIG/profiles/minimal/config.jsonc" --style "$HOME_CONFIG/profiles/minimal/style.css"
fi
