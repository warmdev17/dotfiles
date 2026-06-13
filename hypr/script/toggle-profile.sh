#!/bin/bash

profileFile="$HOME/.config/hypr/current_profile.lua"

if grep -q 'PROFILE = "default"' "$profileFile"; then
    echo 'PROFILE = "minimal"' > "$profileFile"
else
    echo 'PROFILE = "default"' > "$profileFile"
fi

hyprctl reload
