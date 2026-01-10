#!/usr/bin/env bash
# Simple Bluetooth module for Polybar
# deps: bluez, bluez-utils, awk, grep, sed, rofi|dmenu (optional)

ICON_ON=""                                                # cần Nerd Font
ICON_OFF=""                                               # dùng cùng icon, sẽ tô màu khác trong polybar
MENU_LAUNCHER="${ROFI_LAUNCHER:-rofi -dmenu -p Bluetooth}" # fallback dmenu nếu không có rofi

bt_powered() {
  bluetoothctl show | awk -F': ' '/Powered:/ {print $2}'
}

bt_connected_names() {
  # liệt kê tên các device đang connected
  bluetoothctl paired-devices | awk '{print $2}' | while read -r mac; do
    info="$(bluetoothctl info "$mac")"
    echo "$info" | grep -q "Connected: yes" || continue
    name="$(echo "$info" | awk -F': ' '/Name:/ {print substr($0, index($0,$2))}')"
    [ -n "$name" ] && echo "$name"
  done
}

show_status() {
  if [ "$(bt_powered)" != "yes" ]; then
    echo "$ICON_OFF OFF"
    exit 0
  fi
  names="$(bt_connected_names)"
  if [ -z "$names" ]; then
    echo "$ICON_ON Not connected"
  else
    # nếu nhiều, lấy tên đầu + số lượng
    first="$(echo "$names" | head -n1)"
    count="$(echo "$names" | wc -l)"
    if [ "$count" -gt 1 ]; then
      echo "$ICON_ON $first (+$((count - 1)))"
    else
      echo "$ICON_ON $first"
    fi
  fi
}

toggle_power() {
  if [ "$(bt_powered)" = "yes" ]; then
    bluetoothctl power off >/dev/null
  else
    bluetoothctl power on >/dev/null
  fi
}

menu_connect() {
  if [ "$(bt_powered)" != "yes" ]; then
    bluetoothctl power on >/dev/null
    sleep 0.4
  fi

  # danh sách paired + trạng thái
  list=$(bluetoothctl paired-devices | awk '{print $2}' | while read -r mac; do
    name="$(bluetoothctl info "$mac" | awk -F': ' '/Name:/ {print substr($0, index($0,$2))}')"
    connected="$(bluetoothctl info "$mac" | awk -F': ' '/Connected:/ {print $2}')"
    state="󰤭" # disconnected
    [ "$connected" = "yes" ] && state="󰤮"
    printf "%s  %s  (%s)\n" "$state" "$name" "$mac"
  done)

  [ -z "$list" ] && notify-send "Bluetooth" "Chưa có thiết bị paired" && exit 0

  choice=$(echo "$list" | { $MENU_LAUNCHER || dmenu -p Bluetooth; })
  [ -z "$choice" ] && exit 0
  mac="$(echo "$choice" | sed -n 's/.*(\(.*\)).*/\1/p')"

  if echo "$choice" | grep -q "󰤮"; then
    # đang connected -> disconnect
    bluetoothctl disconnect "$mac" >/dev/null && notify-send "Bluetooth" "Đã ngắt $mac"
  else
    # connect
    bluetoothctl connect "$mac" >/dev/null && notify-send "Bluetooth" "Đã kết nối $mac"
    # set profile A2DP nếu là audio (tuỳ hệ, có thể cần thêm pactl)
  fi
}

case "$1" in
--status) show_status ;;
--toggle) toggle_power ;;
--menu) menu_connect ;;
*) show_status ;;
esac
