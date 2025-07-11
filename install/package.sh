#!/bin/bash

echo ">>> Installing packages..."

# Pacman
if [ -f "$(dirname "$0")/package/pkg-pacman.txt" ]; then
  echo "→ Installing pacman packages..."
  xargs -a "$(dirname "$0")/package/pkg-pacman.txt" sudo pacman -S --needed --noconfirm
fi

# AUR
if [ -f "$(dirname "$0")/package/pkg-aur.txt" ]; then
  echo "→ Installing AUR packages..."
  xargs -a "$(dirname "$0")/package/pkg-aur.txt" paru -S --needed --noconfirm
fi

# Brew
if [ -f "$(dirname "$0")/package/pkg-brew.txt" ]; then
  echo "→ Installing brew packages..."
  xargs -a "$(dirname "$0")/package/pkg-brew.txt" brew install
fi

echo "✅ Packages installed."
