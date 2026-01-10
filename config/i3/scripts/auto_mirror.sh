#!/bin/bash

INTERNAL=$(xrandr | grep " connected" | grep -v "HDMI" | awk '{print $1}')

HDMI=$(xrandr | grep " connected" | grep "HDMI" | awk '{print $1}')

if [ -n "$HDMI" ]; then
  xrandr --output "$HDMI" --auto --same-as "$INTERNAL"
fi
