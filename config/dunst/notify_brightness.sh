#!/usr/bin/env bash

cur=$(brightnessctl g)
max=$(brightnessctl m)
percent=$((cur * 100 / max))

dunstify -h int:value:"$percent" -h string:x-dunst-stack-tag:brightness "🔆 Brightness: $percent%"
