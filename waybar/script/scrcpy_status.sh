#!/usr/bin/env bash

if pgrep -x scrcpy >/dev/null; then
  text=" SCRCPY"
  class="active"
  tooltip="scrcpy is running\nLeft click: stop\nRight click: stop"
else
  text=""
  class="idle"
  tooltip="Left click: mirror screen\nRight click: open camera"
fi

cat <<EOF
{
  "text": "$text",
  "class": "$class",
  "tooltip": "$tooltip"
}
EOF
