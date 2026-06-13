#!/usr/bin/env bash

set -euo pipefail

VIDEO_DIR="$HOME/Videos/wallpapers"
IMAGE_DIR="$HOME/Pictures/wallpapers"

CAM_DEVICE="/dev/video10"
WIDTH="1920"
HEIGHT="1080"
FPS="30"

export PATH="/usr/local/bin:/usr/bin:/bin:$HOME/.local/bin:$PATH"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

kill_record_stack() {
  pkill mpvpaper 2>/dev/null || true
  pkill ffmpeg 2>/dev/null || true
  pkill scrcpy 2>/dev/null || true
}

hide_bar() {
  pkill waybar 2>/dev/null || true
}

show_bar() {
  if ! pgrep -x waybar >/dev/null; then
    setsid -f waybar >/tmp/warm-waybar.log 2>&1 </dev/null
  fi
}

camera_mode() {
  kill_record_stack
  hide_bar

  gum spin --title "Starting phone camera..." -- sleep 1

  setsid -f bash -c "
    scrcpy \
      --video-source=camera \
      --camera-id=0 \
      --camera-size='${WIDTH}x${HEIGHT}' \
      --camera-fps='${FPS}' \
      --v4l2-sink='${CAM_DEVICE}' \
      --no-playback \
      --orientation=180
      --no-audio \
      >/tmp/warm-scrcpy.log 2>&1
  " </dev/null

  sleep 2

  setsid -f bash -c "
    ffmpeg \
      -f v4l2 \
      -video_size '${WIDTH}x${HEIGHT}' \
      -framerate '${FPS}' \
      -fflags nobuffer \
      -flags low_delay \
      -i '${CAM_DEVICE}' \
      -vcodec libx264 \
      -preset ultrafast \
      -tune zerolatency \
      -b:v 18M \
      -maxrate 18M \
      -bufsize 1M \
      -pix_fmt yuv420p \
      -f mpegts - 2>/tmp/warm-ffmpeg.log | \
    mpvpaper \
      -o 'no-audio --profile=low-latency --untimed --cache=no --vf=scale=${WIDTH}:${HEIGHT}:flags=lanczos' \
      '*' - \
      >/tmp/warm-mpvpaper.log 2>&1
  " </dev/null

  gum style --foreground 46 "Camera wallpaper mode started."
}

video_mode() {
  kill_record_stack
  hide_bar

  mkdir -p "$VIDEO_DIR"

  video="$(
    find "$VIDEO_DIR" -type f \( \
      -iname "*.mp4" -o \
      -iname "*.mkv" -o \
      -iname "*.webm" -o \
      -iname "*.mov" \
      \) | sort | fzf --prompt="Choose background video: " || true
  )"

  if [[ -z "${video:-}" ]]; then
    gum style --foreground 196 "No video selected."
    exit 0
  fi

  setsid -f mpvpaper \
    -o "no-audio --loop --panscan=1.0 --video-sync=display-resample --vf=scale=${WIDTH}:${HEIGHT}:force_original_aspect_ratio=increase,crop=${WIDTH}:${HEIGHT}" \
    "*" "$video" \
    >/tmp/warm-mpvpaper.log 2>&1 </dev/null

  gum style --foreground 46 "Video wallpaper mode started:"
  gum style --foreground 39 "$video"
}

image_mode() {
  kill_record_stack
  hide_bar

  mkdir -p "$IMAGE_DIR"

  image="$(
    find "$IMAGE_DIR" -type f \( \
      -iname "*.jpg" -o \
      -iname "*.jpeg" -o \
      -iname "*.png" -o \
      -iname "*.webp" \
      \) | sort | fzf \
      --prompt="Choose background image: " \
      --preview='bash -c '"'"'
kitty +kitten icat --clear 2>/dev/null || true
kitty +kitten icat --transfer-mode=file --place="${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}@0x0" "$1"
'"'"' _ {}' \
      --preview-window=right:60% || true
  )"

  if [[ -z "${image:-}" ]]; then
    gum style --foreground 196 "No image selected."
    exit 0
  fi

  if ! command -v awww >/dev/null 2>&1; then
    gum style --foreground 196 "awww not found."
    exit 1
  fi

  # Start daemon if awww has one
  if command -v awww-daemon >/dev/null 2>&1; then
    if ! pgrep -x awww-daemon >/dev/null; then
      setsid -f awww-daemon >/tmp/warm-awww-daemon.log 2>&1 </dev/null
      sleep 0.5
    fi
  fi

  awww img "$image" \
    --resize crop \
    --transition-type fade \
    --transition-duration 0.5 \
    >/tmp/warm-awww.log 2>&1 || {
    gum style --foreground 196 "Failed to set image wallpaper."
    gum style --foreground 214 "Check log: /tmp/warm-awww.log"
    exit 1
  }

  gum style --foreground 46 "Image wallpaper mode started:"
  gum style --foreground 39 "$image"
}

normal_mode() {
  kill_record_stack
  show_bar
  gum style --foreground 46 "Back to normal mode."
}

main() {
  choice="$(
    gum choose \
      "Camera wallpaper mode" \
      "Video wallpaper mode" \
      "Image wallpaper mode" \
      "Normal mode" \
      "Quit" || true
  )"

  case "$choice" in
  "Camera wallpaper mode")
    camera_mode
    ;;
  "Video wallpaper mode")
    video_mode
    ;;
  "Image wallpaper mode")
    image_mode
    ;;
  "Normal mode")
    normal_mode
    ;;
  "Quit" | "")
    exit 0
    ;;
  esac
}

main
