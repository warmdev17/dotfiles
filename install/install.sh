#!/bin/bash

# ====== COLORS & ICONS ======
GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
RED="\033[1;31m"
RESET="\033[0m"
CHECK="✅"
CROSS="❌"
ARROW="➤"

# ====== PATHS ======
DOTFILES_DIR="$(dirname "$(readlink -f "$0")")/.."
CONFIG_DIR="$DOTFILES_DIR/config"
TARGET="$HOME/.config"
SELECTION_FILE="$HOME/.config/.dotfiles-selected"

# ====== STRINGS ======
STR_INSTALL="1) Install dotfiles"
STR_UNINSTALL="2) Uninstall dotfiles"
STR_SELECT_CONFIGS="Select which configs you want (Tab to select multiple):"
STR_NO_SELECTION="No selection made. Exiting."
STR_CHOICE_PROMPT="→ Enter your choice (1 or 2): "
STR_INVALID="Invalid choice. Exiting."
STR_DONE_INSTALL="Finished installing selected dotfiles."
STR_DONE_UNINSTALL="Finished removing selected dotfiles."
STR_TITLE="Dotfiles Installer with FZF"

# ====== HEADER ======
print_header() {
  echo -e "${BLUE}"
  echo "╭────────────────────────────────────────╮"
  printf "│ %-38s │\n" "$STR_TITLE"
  echo "╰────────────────────────────────────────╯"
  echo -e "${RESET}"
}

# ====== CHECK DEPENDENCIES ======
check_dependencies() {
  if ! command -v stow &>/dev/null; then
    echo -e "${YELLOW}${ARROW} Installing stow...${RESET}"
    sudo pacman -S stow --noconfirm || brew install stow
  fi

  if ! command -v fzf &>/dev/null; then
    echo -e "${RED}${CROSS} fzf is not installed. Please install it (e.g., sudo pacman -S fzf).${RESET}"
    exit 1
  fi
}

# ====== SELECT CONFIGS ======
select_configs() {
  cd "$CONFIG_DIR" || exit 1

  echo -e "${YELLOW}${ARROW} $STR_SELECT_CONFIGS${RESET}"

  all_configs=$(find . -mindepth 1 -maxdepth 1 -type d | sed 's|./||')

  if [ -f "$SELECTION_FILE" ]; then
    selected=$(echo "$all_configs" | fzf -m --query "$(cat "$SELECTION_FILE" | paste -sd ' ' -)")
  else
    selected=$(echo "$all_configs" | fzf -m)
  fi

  if [ -z "$selected" ]; then
    echo -e "${RED}${CROSS} $STR_NO_SELECTION${RESET}"
    exit 1
  fi

  echo "$selected" >"$SELECTION_FILE"
  echo "$selected"
}

# ====== STOW ======
stow_selected() {
  for dir in "$@"; do
    echo -e "${GREEN}${ARROW} Installing: $dir${RESET}"
    stow -t "$TARGET" -d "$CONFIG_DIR" "$dir"
  done
  echo -e "${GREEN}${CHECK} $STR_DONE_INSTALL${RESET}"
}

# ====== UNSTOW ======
unstow_selected() {
  for dir in "$@"; do
    echo -e "${RED}${ARROW} Removing: $dir${RESET}"
    stow -D -t "$TARGET" -d "$CONFIG_DIR" "$dir"
  done
  echo -e "${RED}${CHECK} $STR_DONE_UNINSTALL${RESET}"
}

# ====== MAIN ======
main() {
  print_header
  check_dependencies

  read -rp "→ Do you want to install packages from pkg-*.txt first? (y/n): " install_pkg
  if [[ "$install_pkg" == [Yy]* ]]; then
    bash "$DOTFILES_DIR/package.sh"
  fi

  echo -e "${BLUE}$STR_INSTALL\n$STR_UNINSTALL${RESET}"
  read -rp "$STR_CHOICE_PROMPT" choice

  selected=$(select_configs)

  if [ "$choice" = "1" ]; then
    stow_selected $selected
  elif [ "$choice" = "2" ]; then
    unstow_selected $selected
  else
    echo -e "${RED}${CROSS} $STR_INVALID${RESET}"
    exit 1
  fi
}

main "$@"
