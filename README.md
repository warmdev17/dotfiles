# 🛠️ Dotfiles for Arch Linux

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
bash <(curl -s https://raw.githubusercontent.com/warmdev17/dotfiles/main/setup.sh)
```

This will:

- Install Git (if needed)

- Clone your dotfiles repo to ~/.dotfiles

- Launch an interactive installer:

- Optionally install packages

- Select dotfiles folders to install (via FZF)

- Symlink configs into ~/.config using stow

- Your last folder selection is saved to ~/.config/.dotfiles-selected and auto-loaded next time.

## 🧱 Folder Structure

```

```

dotfiles/
├── config/ # Symlinked to ~/.config/
│ ├── fish/
│ ├── nvim/
│ ├── kitty/
│ └── ...
├── etc/ # Optional: for /etc (e.g. modprobe)
├── local/ # Optional: ~/.local/share/
├── usr/ # Optional: /usr/share/ configs
├── install/
│ ├── install.sh # Interactive CLI installer
│ ├── package.sh # Auto-installs packages (optional)
│ └── package/
│ ├── pkg-pacman.txt # Pacman packages
│ ├── pkg-aur.txt # AUR packages
│ └── pkg-brew.txt # Homebrew packages
├── setup.sh # One-line installer entrypoint
└── README.md

```

```

## 📚 Manual Usage

Clone and install manually:

```
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles
chmod +x install/install.sh install/package.sh
./install/install.sh
```

```

```

You'll be guided through:

- Selecting packages to install from pkg-\*.txt (optional)

- Choosing which config to install or uninstall

- Linking them with stow into the appropriate locations

## 📦 Managing Your Packages

To have the installer automatically install your software, add them to these files:

- install/package/pkg-pacman.txt – for pacman packages

- install/package/pkg-aur.txt – for AUR packages (using yay or paru)

- install/package/pkg-brew.txt – for Homebrew (macOS or Linuxbrew)

The installer reads these and runs appropriate package managers.

## 💡 Tips

- Re-run ./install/install.sh anytime to add/remove configs

- Use stow -D -t ~/.config <dir> to manually unstow

- Avoid committing generated folders like:

  - plugged/, node_modules/, .cache/, .local/share/...

## 🎨 Example Setup

- WM: i3

- Terminal: Kitty

- Shell: Fish

- Launcher: Rofi

- Bar: Polybar

- Editor: Neovim (Lua-based)
