#!/usr/bin/env bash

# kill old sessions
pkill mpvpaper
pkill ffmpeg
pkill scrcpy
pkill waybar

# start phone camera
scrcpy \
  --video-source=camera \
  --camera-id=0 \
  --camera-size=1920x1080 \
  --camera-fps=30 \
  --v4l2-sink=/dev/video10 \
  --no-playback \
  --no-audio &

sleep 2

# set wallpaper camera
ffmpeg \
  -f v4l2 \
  -video_size 1920x1080 \
  -framerate 30 \
  -fflags nobuffer \
  -flags low_delay \
  -i /dev/video10 \
  -vcodec libx264 \
  -preset ultrafast \
  -tune zerolatency \
  -b:v 18M \
  -pix_fmt yuv420p \
  -f mpegts - |
  mpvpaper \
    -o 'no-audio --profile=low-latency --untimed --cache=no --vf=scale=1920:1080:flags=lanczos' \
    '*' -
