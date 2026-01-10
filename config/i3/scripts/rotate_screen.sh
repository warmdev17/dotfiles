#!/bin/bash

OUTPUT="eDP"
CURRENT=$(xrandr --verbose | grep "$OUTPUT connected" -A5 | grep -oP 'rotate \K\w+')

case "$CURRENT" in
normal) xrandr --output "$OUTPUT" --rotate right ;;
right) xrandr --output "$OUTPUT" --rotate inverted ;;
inverted) xrandr --output "$OUTPUT" --rotate left ;;
left) xrandr --output "$OUTPUT" --rotate normal ;;
*) xrandr --output "$OUTPUT" --rotate normal ;;
esac
