#!/bin/bash

# === CẤU HÌNH ===
REPO_URL="https://github.com/warmdev17/dotfiles.git"
TARGET_DIR="$HOME/dotfiles"

# === MÀU SẮC ===
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# === BANNER ===
echo -e "${GREEN}📦 Setting up your dotfiles from GitHub...${RESET}"

# === BƯỚC 1: CÀI GIT NẾU CHƯA CÓ ===
if ! command -v git &>/dev/null; then
  echo -e "${YELLOW}⚠️ Git is not installed. Installing...${RESET}"
  sudo pacman -S git --noconfirm || sudo apt install git -y || brew install git
fi

# === BƯỚC 2: CLONE REPO ===
if [ -d "$TARGET_DIR" ]; then
  echo -e "${YELLOW}⚠️ Dotfiles already exist at $TARGET_DIR. Skipping clone.${RESET}"
else
  git clone "$REPO_URL" "$TARGET_DIR"
fi

# === BƯỚC 3: CHMOD & CHẠY INSTALLER ===
cd "$TARGET_DIR" || exit 1
chmod +x ./install/install.sh ./install/package.sh
./install/install.sh
