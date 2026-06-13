#!/usr/bin/env bash

WALLDIR="$HOME/Pictures/test"
THUMBDIR="$HOME/.cache/wallthumbs"

mkdir -p "$THUMBDIR"

entries=""

for img in "$WALLDIR"/*.{jpg,jpeg,png,webp}; do
  [ -e "$img" ] || continue

  name=$(basename "$img")
  thumb="$THUMBDIR/$name.png"

  if [ ! -f "$thumb" ]; then
    magick "$img" -resize 256x256 "$thumb"
  fi

  entries+="$name\x00icon\x1f$thumb\n"
done

selected=$(echo -e "$entries" | rofi -dmenu -theme ~/.config/rofi/wallpaper.rasi)

[ -z "$selected" ] && exit 0

awww img "$WALLDIR/$selected" --transition-type center
