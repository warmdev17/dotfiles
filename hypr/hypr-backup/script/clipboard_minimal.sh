#!/usr/bin/env bash

tmp_dir="/tmp/cliphist"
rm -rf "$tmp_dir"

if [[ -n "$1" ]]; then
  cliphist decode <<<"$1" | wl-copy
  exit
fi

mkdir -p "$tmp_dir"

read -r -d '' prog <<'EOF'
/^[0-9]+\s<meta http-equiv=/ { next }

match($0, /^([0-9]+).*binary.*(jpg|jpeg|png|bmp)/, grp) {
    cmd = "printf \"%s\" \"" grp[1] "\" | cliphist decode > /tmp/cliphist/" grp[1] "." grp[2]
    system(cmd)
    print $0 "\0icon\x1f/tmp/cliphist/" grp[1] "." grp[2]
    next
}

1
EOF

# ---- ROFI ----
selection=$(
  cliphist list | gawk "$prog" | rofi -dmenu -theme ~/.config/rofi/cliphist_minimal.rasi
)

[[ -z "$selection" ]] && exit 0

# Gọi lại script với item đã chọn
"$0" "$selection"
