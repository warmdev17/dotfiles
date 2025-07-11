DD=~/dotfiles/config
DL=~/dotfiles
sudo ln -sf ~/dotfiles/local/share/rofi ~/.local/share/rofi
sudo ln -sf ~/dotfiles/usr/share/sddm /usr/share/sddm
sudo ln -sf ~/dotfiles/usr/share/X11 /usr/share/X11

mv $DD/tmux/* ~/
cp -r $DL/local/share/rofi/themes/catppuccin-macchiato.rasi $DD.local/share/rofi/themes/
cp -r $DD/oh-my-posh/catppuccin_mocha.omp.json $DD
sudo mv $DD/etc/modprobe.d/hid_apple.conf /etc/modprobe.d/hid_apple.conf
cp -r $DL/scripts/ibus.sh ~/
cp -r $DL/scripts/polybar-i3.sh ~/
