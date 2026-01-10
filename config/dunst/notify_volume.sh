#!/usr/bin/env bash

vol=$(pamixer --get-volume)
mute=$(pamixer --get-mute)

if [ "$mute" = "true" ]; then
  dunstify -h string:x-dunst-stack-tag:volume "🔇 Muted"
else
  dunstify -h int:value:"$vol" -h string:x-dunst-stack-tag:volume "🔊 Volume: $vol%"
fi
