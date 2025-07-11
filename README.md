# 🛠️ Dotfiles for Arch Linux + Hyprland / WM Setup

> Personal, modular dotfiles powered by [stow](https://www.gnu.org/software/stow/), [fzf](https://github.com/junegunn/fzf), and optional package installation.

---

## 📦 Requirements

- `bash`
- `stow`
- `fzf`
- (Optional) `yay` or `paru` for AUR packages

Install on Arch-based:

```bash
sudo pacman -S stow fzf
```

## 🚀 Quick Setup

```
bash <(curl -s https://raw.githubusercontent.com/warmdev/dotfiles/main/setup.sh)
```

This will:

- Install Git (if needed)

- Clone your dotfiles repo to ~/.dotfiles

- Launch an interactive installer:

- Optionally install packages

- Select dotfiles folders to install (via FZF)

- Symlink configs into ~/.config using stow

- Your last folder selection is saved to ~/.config/.dotfiles-selected and auto-loaded next time.

## 📚 Usage
