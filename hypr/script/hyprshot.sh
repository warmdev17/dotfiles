#!/bin/bash
set -e

# =========================
# CONFIG
# =========================
SAVEDIR="$HOME/Pictures/Screenshots"
mkdir -p "$SAVEDIR"

IMG_NAME="screenshot_$(date +'%Y-%m-%d_%H-%M-%S')"
TIMEOUT=5000

mode="$1"   # fullscreen | region | window
target="$2" # file | clipboard

# =========================
# CHECK ARGUMENTS
# =========================
if [[ -z "$mode" || -z "$target" ]]; then
  echo "Usage: $0 {fullscreen|region|window} {file|clipboard}"
  exit 1
fi

# =========================
# NOTIFICATION
# =========================
notify() {
  notify-send "Screenshot: $mode" \
    "Copied to clipboard$([[ "$target" == "file" ]] && echo ' and saved')" \
    -t "$TIMEOUT"
}

# =========================
# SAVE PIPE
# =========================
save_pipe() {
  if [[ "$target" == "file" ]]; then
    tee "$SAVEDIR/${IMG_NAME}-${mode}.png" | wl-copy
  else
    wl-copy
  fi
}

# =========================
# SCREENSHOT LOGIC
# =========================
case "$mode" in
fullscreen)
  grim - | save_pipe
  ;;

region)
  geometry=$(slurp)
  [[ -z "$geometry" ]] && exit 0
  grim -g "$geometry" - | save_pipe
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
  grim -g "$geometry" - | save_pipe
  ;;

*)
  echo "Invalid mode: $mode"
  exit 1
  ;;
esac

notify
