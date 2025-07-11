#!/bin/bash

# Check if ibus-daemon is running
if ! pidof ibus-daemon >/dev/null; then
  # Start ibus-daemon if not running
  ibus-daemon -drx
fi
