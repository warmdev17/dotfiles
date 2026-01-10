#!/usr/bin/env bash
# Polybar Timer — countdown & count-up with click controls
# deps: bash 4+, date, sed, awk; optional: notify-send
# actions (bind in polybar):
#   toggle, reset, +N, -N, preset {work|break|long}, mode {down|up}
# run as: polybar-timer.sh daemon   # prints timer every second (tail mode)
set -euo pipefail

STATE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/polybar/timer"
STATE_FILE="$STATE_DIR/state"
LOCK_FILE="$STATE_DIR/.lock"
mkdir -p "$STATE_DIR"

# defaults
DEFAULT_MODE="down" # down|up
DEFAULT_WORK=1500   # 25m
DEFAULT_BREAK=300   # 5m
DEFAULT_LONG=900    # 15m
DEFAULT_TOTAL=$DEFAULT_WORK
DEFAULT_STEP=60         # scroll step in seconds
ICON="${ICON_TIMER:-}" # Font Awesome clock, change if needed
DONE_ICON="${ICON_DONE:-}"
ALERT_SOUND="${ALERT_SOUND:-}" # set to e.g. /usr/share/sounds/freedesktop/stereo/complete.oga

have_notify() { command -v notify-send >/dev/null 2>&1; }

init_state() {
  cat >"$STATE_FILE" <<EOF
running=0
mode=$DEFAULT_MODE
total=$DEFAULT_TOTAL
base= $DEFAULT_TOTAL
base_up=0
last_update=$(date +%s)
step=$DEFAULT_STEP
EOF
}

load_state() {
  [[ -f "$STATE_FILE" ]] || init_state
  # shellcheck disable=SC1090
  source "$STATE_FILE"
}

save_state() {
  local tmp="$STATE_FILE.tmp.$$"
  {
    echo "running=$running"
    echo "mode=$mode"
    echo "total=$total"
    echo "base=$base"
    echo "base_up=$base_up"
    echo "last_update=$last_update"
    echo "step=$step"
  } >"$tmp"
  mv "$tmp" "$STATE_FILE"
}

with_lock() {
  exec 9>"$LOCK_FILE"
  flock -w 1 9 || exit 0
  "$@"
}

fmt_time() {
  local s=$1 h m
  ((s < 0)) && s=0
  h=$((s / 3600))
  m=$(((s % 3600) / 60))
  s=$((s % 60))
  if ((h > 0)); then
    printf "%d:%02d:%02d" "$h" "$m" "$s"
  else
    printf "%02d:%02d" "$m" "$s"
  fi
}

# compute current displayed seconds based on state & now
current_value() {
  local now elapsed
  now=$(date +%s)
  if [[ "$mode" == "down" ]]; then
    if ((running)); then
      elapsed=$((now - last_update))
      printf '%d\n' $((base - elapsed))
    else
      printf '%d\n' "$base"
    fi
  else
    # up mode
    if ((running)); then
      elapsed=$((now - last_update))
      printf '%d\n' $((base_up + elapsed))
    else
      printf '%d\n' "$base_up"
    fi
  fi
}

notify_done() {
  if have_notify; then
    notify-send -a "Timer" "Time's up" "Timer finished." -u normal -i appointment-soon
  fi
  if [[ -n "$ALERT_SOUND" && -r "$ALERT_SOUND" ]]; then
    (paplay "$ALERT_SOUND" 2>/dev/null || aplay "$ALERT_SOUND" 2>/dev/null || true) &
  fi
}

cmd_toggle() {
  with_lock bash -c '
    load_state
    now=$(date +%s)
    if [[ "$mode" == "down" ]]; then
      # capture current remaining
      if (( running )); then
        elapsed=$(( now - last_update ))
        base=$(( base - elapsed ))
        (( base < 0 )) && base=0
        running=0
      else
        last_update=$now
        running=1
      fi
    else
      # up mode
      if (( running )); then
        elapsed=$(( now - last_update ))
        base_up=$(( base_up + elapsed ))
        (( base_up < 0 )) && base_up=0
        running=0
      else
        last_update=$now
        running=1
      fi
    fi
    save_state
  '
}

cmd_reset() {
  with_lock bash -c '
    load_state
    now=$(date +%s)
    if [[ "$mode" == "down" ]]; then
      base=$total
      running=0
    else
      base_up=0
      running=0
    fi
    last_update=$now
    save_state
  '
}

cmd_adjust() {
  local delta=${1:-0}
  with_lock bash -c '
    load_state
    now=$(date +%s)
    if [[ "$mode" == "down" ]]; then
      # compute current remaining then adjust and pause
      elapsed=$(( running ? (now - last_update) : 0 ))
      cur=$(( base - elapsed ))
      cur=$(( cur + '"$delta"' ))
      (( cur < 0 )) && cur=0
      base=$cur
      running=0
    else
      # up mode: adjust base_up and pause
      elapsed=$(( running ? (now - last_update) : 0 ))
      cur=$(( base_up + elapsed + '"$delta"' ))
      (( cur < 0 )) && cur=0
      base_up=$cur
      running=0
    fi
    last_update=$now
    save_state
  '
}

cmd_preset() {
  local which=${1:-work}
  local val
  case "$which" in
  work) val=$DEFAULT_WORK ;;
  break) val=$DEFAULT_BREAK ;;
  long) val=$DEFAULT_LONG ;;
  [0-9]*) val=$which ;; # seconds directly
  *) val=$DEFAULT_WORK ;;
  esac
  with_lock bash -c '
    load_state
    now=$(date +%s)
    mode=down
    total='"$val"'
    base=$total
    running=0
    last_update=$now
    save_state
  '
}

cmd_mode() {
  local m=${1:-down}
  [[ "$m" == "down" || "$m" == "up" ]] || m="down"
  with_lock bash -c '
    load_state
    now=$(date +%s)
    mode='"$m"'
    # pause when switching
    if (( running )); then
      if [[ "$mode" == "down" ]]; then
        elapsed=$(( now - last_update ))
        base=$(( base - elapsed ))
        (( base < 0 )) && base=0
      else
        elapsed=$(( now - last_update ))
        base_up=$(( base_up + elapsed ))
      fi
      running=0
    fi
    last_update=$now
    save_state
  '
}

render() {
  load_state
  local val
  val=$(current_value)
  if [[ "$mode" == "down" ]]; then
    if ((val <= 0)); then
      # finished
      running=0
      base=0
      save_state
      echo "$DONE_ICON 00:00"
      notify_done
      return
    fi
    local out
    out=$(fmt_time "$val")
    if ((running)); then
      echo "$ICON $out"
    else
      echo "$ICON [$out]"
    fi
  else
    # up mode
    local out
    out=$(fmt_time "$val")
    if ((running)); then
      echo "$ICON +$out"
    else
      echo "$ICON [+${out}]"
    fi
  fi
}

daemon() {
  # ensure state exists
  [[ -f "$STATE_FILE" ]] || init_state
  # print immediately, then every second
  while :; do
    render
    sleep 1
  done
}

case "${1:-}" in
daemon) daemon ;;
toggle) cmd_toggle ;;
reset) cmd_reset ;;
+*) cmd_adjust "${1#'+']}" ;; # +N
-*) cmd_adjust "${1}" ;;      # -N
preset) cmd_preset "${2:-work}" ;;
mode) cmd_mode "${2:-down}" ;;
*)
  echo "Usage: $0 {daemon|toggle|reset|+N|-N|preset {work|break|long|SECONDS}|mode {down|up}}"
  exit 2
  ;;
esac
