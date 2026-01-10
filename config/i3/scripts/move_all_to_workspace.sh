#!/bin/bash

target=$1
current_ws=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')

i3-msg "[workspace=\"$current_ws\"] move container to workspace $target"
i3-msg workspace "$target"
