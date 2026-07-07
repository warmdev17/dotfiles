#!/bin/bash
set -e

# =========================
# CONFIG
# =========================
SAVEDIR="$HOME/Pictures/Screenshots"
TMPDIR="/tmp/hyprshot"
mkdir -p "$SAVEDIR" "$TMPDIR"

IMG_NAME="screenshot_$(date +'%a-%d-%m-%Y_%Hh-%Mm-%Ss')"
TIMEOUT=4000
SOUND="/home/warmdev/Music/sound/screenshot.mp3"

mode="$1"    # fullscreen | region | window
target="$2"  # file | clipboard
preview="$3" # preview (optional)

# =========================
# CHECK ARGUMENTS
# =========================
if [[ -z "$mode" || -z "$target" ]]; then
  echo "Usage: $0 {fullscreen|region|window} {file|clipboard} [preview]"
  exit 1
fi

# =========================
# PATH RESOLUTION
# =========================
if [[ "$target" == "file" ]]; then
  OUTFILE="$SAVEDIR/${IMG_NAME}-${mode}.png"
else
  OUTFILE="$TMPDIR/${IMG_NAME}-${mode}.png"
fi

# =========================
# SOUND
# =========================
play_sound() {
  [[ -f "$SOUND" ]] && paplay "$SOUND" &
}

# =========================
# NOTIFICATION
# =========================
notify() {
  notify-send "Screenshot: $mode" \
    "Copied to clipboard$([[ "$target" == "file" ]] && echo ' and saved')" \
    -t "$TIMEOUT"
}

# =========================
# PREVIEW
# =========================
show_preview() {
  [[ "$preview" != "preview" ]] && return 0

  feh "$OUTFILE" \
    --title "Screenshot preview" \
    --borderless \
    --auto-zoom \
    --scale-down \
    --geometry +30+30 \
    --class "feh-preview" &
}

# =========================
# FINALIZE IMAGE
# =========================
finalize() {
  wl-copy <"$OUTFILE"
  show_preview
  notify
}

# =========================
# SCREENSHOT LOGIC
# =========================
case "$mode" in
fullscreen)
  play_sound
  grim "$OUTFILE"
  ;;

region)
  geometry=$(slurp)
  [[ -z "$geometry" ]] && exit 0
  play_sound
  grim -g "$geometry" "$OUTFILE"
  ;;

window)
  activeWs=$(hyprctl -j monitors | jq '[.[] | .activeWorkspace.id]')

  geometry=$(
    hyprctl -j clients |
      jq -r --argjson ws "$activeWs" '
          .[]
          | select(.size[0] > 0 and .size[1] > 0)
          | select(.workspace.id as $id | $ws | index($id))
          | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"
        ' |
      slurp -r
  )

  [[ -z "$geometry" ]] && exit 0
  play_sound
  grim -g "$geometry" "$OUTFILE"
  ;;

*)
  echo "Invalid mode: $mode"
  exit 1
  ;;
esac

finalize
