#!/bin/bash

profileFile="$HOME/.config/hypr/current_profile.lua"

if grep -q 'return "default"' "$profileFile"; then
    echo 'return "minimal"' > "$profileFile"
else
    echo 'return "default"' > "$profileFile"
fi
