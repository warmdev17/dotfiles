#!/usr/bin/env bash

IMG="/tmp/hyprlock.png"

pidof hyprlock >/dev/null && exit 0

grim "$IMG" 2>/dev/null || true

exec hyprlock
