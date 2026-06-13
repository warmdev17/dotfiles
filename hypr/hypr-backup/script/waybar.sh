#!/bin/bash

kill $(pidof waybar) 2>/dev/null

waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css
