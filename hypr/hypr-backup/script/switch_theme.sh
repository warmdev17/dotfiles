#!/bin/bash

THEME=$1
ln -sf ~/.config/hypr/$THEME/hyprland.conf ~/.config/hypr/current_theme/hyprland.conf
echo "$THEME" >~/.cache/current_theme

# reload hypr
hyprctl reload
