#!/usr/bin/env bash
# Polybar scrcpy status (ADB/OTG/Camera/Record-time) — tail-friendly
# deps: bash 4+, adb, pgrep, ps, awk, sed, grep
# optional: xdotool hoặc wmctrl (để dò cửa sổ scrcpy, tránh false MIRROR)

set -u
LC_ALL=C

# ── Catppuccin Mocha palette ────────────────────────────────────────────────
bg="#1e1e2e"
bg_alt="#45475a"
fg="#f5e0dc"
primary="#cba6f7"
secondary="#8ABEB7"
alert="#f38ba8"
disabled="#707880"
warning="#fab387"

text="#cdd6f4"
info="#89b4fa"
ok="#a6e3a1"
muted="#707880"

ICON_PHONE=""
SEP="  |  "

# ── Helpers ─────────────────────────────────────────────────────────────────
fmt_dur() { # seconds -> H:MM:SS
  local s=$1 h m
  ((s < 0)) && s=0
  h=$((s / 3600))
  m=$(((s % 3600) / 60))
  s=$((s % 60))
  printf "%d:%02d:%02d" "$h" "$m" "$s"
}

# Kiểm tra có cửa sổ scrcpy (yêu cầu xdotool hoặc wmctrl nếu có)
has_scrcpy_window() {
  if command -v xdotool >/dev/null 2>&1; then
    xdotool search --classname scrcpy >/dev/null 2>&1 && return 0
    xdotool search --name '[Ss]crcpy' >/dev/null 2>&1 && return 0
  fi
  if command -v wmctrl >/dev/null 2>&1; then
    wmctrl -lx | grep -qi 'scrcpy' && return 0
  fi
  return 2 # không biết (không có công cụ dò window)
}

# Chỉ nhận PID nếu không phải zombie/stopped
proc_alive() {
  local pid="$1"
  local st
  st=$(ps -o state= -p "$pid" 2>/dev/null | tr -d ' ')
  [[ "$st" =~ ^[RSDI]$ ]] && return 0 # Running/Sleeping/Uninterruptible/Idle
  return 1
}

# ── One-shot render (dùng cho tail loop) ────────────────────────────────────
render_once() {
  # require adb
  if ! command -v adb >/dev/null 2>&1; then
    echo "%{F$alert}$ICON_PHONE adb?%{F-}"
    return
  fi

  # lấy đúng tiến trình 'scrcpy' (không dính script khác)
  if PROCS_RAW=$(pgrep -ax scrcpy 2>/dev/null); then
    mapfile -t PROCS < <(printf "%s\n" "$PROCS_RAW")
  else
    PROCS=()
  fi

  # build adb devices (state=device)
  declare -A MODEL_BY_SERIAL TRANSPORT_BY_SERIAL
  mapfile -t DEVLINES < <(adb devices -l 2>/dev/null | awk '$2=="device"{print $0}')
  for ln in "${DEVLINES[@]:-}"; do
    serial=$(awk '{print $1}' <<<"$ln")
    [[ -z "$serial" ]] && continue
    model=$(sed -n 's/.*model:\([^ ]*\).*/\1/p' <<<"$ln")
    [[ -z "$model" ]] && model=$(sed -n 's/.*device:\([^ ]*\).*/\1/p' <<<"$ln")
    model=${model//_/ }
    [[ "$serial" == *:* ]] && TRANSPORT_BY_SERIAL["$serial"]="Wi-Fi" || TRANSPORT_BY_SERIAL["$serial"]="USB"
    MODEL_BY_SERIAL["$serial"]="${model:-$serial}"
  done

  DEVCOUNT=${#DEVLINES[@]}
  PROCCOUNT=${#PROCS[@]}

  # nothing at all
  if ((DEVCOUNT == 0 && PROCCOUNT == 0)); then
    echo "%{F$disabled}$ICON_PHONE OFF%{F-}"
    return
  fi

  # no ADB devices → CHỈ báo nếu là OTG, ngược lại coi như OFF
  if ((DEVCOUNT == 0)); then
    if ((PROCCOUNT > 0)) && printf "%s\n" "${PROCS[@]}" | grep -q -- "--otg"; then
      out="%{F$ok}$ICON_PHONE OTG%{F-}"
      while IFS= read -r line; do
        pid="${line%% *}"
        cmd="${line#* }"
        if grep -Eq -- "--record=|--output=" <<<"$cmd"; then
          et=$(ps -o etimes= -p "$pid" 2>/dev/null | tr -d ' ')
          [[ -n "$et" ]] && out="$out %{F$alert}REC $(fmt_dur "$et")%{F-}"
          break
        fi
      done < <(printf "%s\n" "${PROCS[@]}")
      echo "$out"
    else
      echo "%{F$disabled}$ICON_PHONE OFF%{F-}"
    fi
    return
  fi

  # match procs to devices by serial
  declare -a ENTRIES
  declare -A USED_SERIAL

  proc_for_serial() {
    local ser="$1" line pid cmd
    while IFS= read -r line; do
      pid="${line%% *}"
      cmd="${line#* }"
      if grep -Eq "(^|[[:space:]])(-s[[:space:]]+$ser|--serial=*$ser)($|[[:space:]])" <<<"$cmd"; then
        echo "$line"
        return 0
      fi
    done < <(printf "%s\n" "${PROCS[@]}")
    return 1
  }

  # explicit matches
  for ln in "${DEVLINES[@]}"; do
    serial=$(awk '{print $1}' <<<"$ln")
    [[ -z "$serial" ]] && continue
    if match=$(proc_for_serial "$serial"); then
      ENTRIES+=("$serial|$match")
      USED_SERIAL["$serial"]=1
    fi
  done

  # 1 device: implicit gán proc không -s (chỉ khi có cửa sổ)
  if ((DEVCOUNT == 1 && PROCCOUNT > 0)); then
    sole_serial=$(awk '{print $1}' <<<"${DEVLINES[0]}")
    if [[ -n "$sole_serial" && -z "${USED_SERIAL[$sole_serial]:-}" ]]; then
      if ((PROCCOUNT == 1)); then
        pid="${PROCS[0]%% *}"
        cmd="${PROCS[0]#* }"
        if proc_alive "$pid" && ! grep -Eq "(^|[[:space:]])(-s|--serial=)" <<<"$cmd"; then
          if has_scrcpy_window; then
            ENTRIES+=("$sole_serial|${PROCS[0]}")
            USED_SERIAL["$sole_serial"]=1
          else
            # nếu không có xdotool/wmctrl, cho qua để không phá use-case cũ
            if ! command -v xdotool >/dev/null 2>&1 && ! command -v wmctrl >/dev/null 2>&1; then
              ENTRIES+=("$sole_serial|${PROCS[0]}")
              USED_SERIAL["$sole_serial"]=1
            fi
          fi
        fi
      else
        # nhiều proc: nhận proc không -s & có flag & alive & có window
        while IFS= read -r line; do
          pid="${line%% *}"
          cmd="${line#* }"
          if ! grep -Eq "(^|[[:space:]])(-s|--serial=)" <<<"$cmd" && [[ "$cmd" != "scrcpy" ]] && proc_alive "$pid"; then
            if has_scrcpy_window; then
              ENTRIES+=("$sole_serial|$line")
              USED_SERIAL["$sole_serial"]=1
              break
            else
              if ! command -v xdotool >/dev/null 2>&1 && ! command -v wmctrl >/dev/null 2>&1; then
                ENTRIES+=("$sole_serial|$line")
                USED_SERIAL["$sole_serial"]=1
                break
              fi
            fi
          fi
        done < <(printf "%s\n" "${PROCS[@]}")
      fi
    fi
  fi

  # idle devices
  for ln in "${DEVLINES[@]}"; do
    serial=$(awk '{print $1}' <<<"$ln")
    [[ -z "$serial" ]] && continue
    if [[ -z "${USED_SERIAL[$serial]:-}" ]]; then
      ENTRIES+=("$serial|IDLE")
    fi
  done

  # render (không hiện (USB/Wi-Fi))
  OUT=""
  for entry in "${ENTRIES[@]}"; do
    serial="${entry%%|*}"
    rest="${entry#*|}"
    model="${MODEL_BY_SERIAL[$serial]:-$serial}"

    if [[ "$rest" == "IDLE" ]]; then
      piece="%{F$warning}$ICON_PHONE $model%{F-} %{F$disabled}idle%{F-}"
    else
      pid="${rest%% *}"
      cmd="${rest#* }"
      mode_labels=()
      grep -q -- "--otg" <<<"$cmd" && mode_labels+=("OTG")
      grep -q -- "--no-playback" <<<"$cmd" && mode_labels+=("NoPlbk")
      grep -q -- "--no-window" <<<"$cmd" && mode_labels+=("NoWin")
      if grep -q -- "--video-source=camera" <<<"$cmd"; then
        face=""
        [[ "$cmd" =~ --camera-facing=(front|back) ]] && face="${BASH_REMATCH[1]}"
        [[ -n "$face" ]] && mode_labels+=("CAM:$face") || mode_labels+=("CAM")
      fi
      rec=""
      if grep -Eq -- "--record=|--output=" <<<"$cmd"; then
        et=$(ps -o etimes= -p "$pid" 2>/dev/null | tr -d ' ')
        [[ -n "$et" ]] && rec=" %{F$alert}REC $(fmt_dur "$et")%{F-}" || rec=" %{F$alert}REC%{F-}"
      fi
      ((${#mode_labels[@]} == 0)) && mode_labels=("Mirror")
      mode_str=$(
        IFS=/
        echo "${mode_labels[*]}"
      )
      piece="%{F$ok}$ICON_PHONE $model%{F-} %{F$info}$mode_str%{F-}$rec"
    fi

    [[ -z "$OUT" ]] && OUT="$piece" || OUT="$OUT$SEP$piece"
  done

  echo "$OUT"
}

# ── Tail mode: in ra mỗi 1s cho Polybar tail=true ───────────────────────────
if [[ "${1:-}" == "--tail" ]]; then
  # warm-up một dòng để Polybar hiện module ngay
  echo ""
  while true; do
    render_once
    sleep 1
  done
else
  render_once
fi
