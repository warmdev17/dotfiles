#!/usr/bin/env bash

# Kill already running polybar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch a specific bar (change "mybar" to your bar name)
polybar example -c ~/.config/polybar/config.ini &

echo "Polybar launched 🚀"
