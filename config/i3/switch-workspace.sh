#!/bin/bash

direction="$1"

# Lấy danh sách các workspace, sắp xếp theo số
workspaces=($(i3-msg -t get_workspaces | jq 'sort_by(.num) | .[].num'))

# Lấy workspace hiện tại
current=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).num')

# Tìm chỉ số của workspace hiện tại trong danh sách
for i in "${!workspaces[@]}"; do
  if [[ "${workspaces[$i]}" = "${current}" ]]; then
    current_index=$i
    break
  fi
done

# Di chuyển
if [[ "$direction" == "next" && $((current_index + 1)) -lt ${#workspaces[@]} ]]; then
  i3-msg workspace number "${workspaces[$((current_index + 1))]}"
elif [[ "$direction" == "prev" && $((current_index - 1)) -ge 0 ]]; then
  i3-msg workspace number "${workspaces[$((current_index - 1))]}"
fi
