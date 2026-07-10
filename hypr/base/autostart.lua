return {
	fcitx_gtk = "set -Ux GTK_IM_MODULE=fcitx5",
	fcitx_qt1 = "set -Ux QT_IM_MODULE=fcitx5",
	fcitx_qt2 = "set -Ux QT_IM_MODULE=fcitx5",
	fcitx_xmod = "set -Ux XMODIFIERS=@im=fcitx5",
	fcitx_input = "set -Ux INPUT_METHOD=fcitx5",
	fcitx_sdl = "set -Ux SDL_IM_MODULE=fcitx5",
	fcitx_daemon = "fcitx5",

	power_btn = "hyprctl keyword 'device[power-button]:enabled' false",
	dbus = "dbus-update-activation-environment --all",
	keyring = "gnome-keyring-daemon --start --components=secrets",
	cliphist_text = "wl-paste --type text --watch cliphist store",
	cliphist_image = "wl-paste --type image --watch cliphist store",
	cliphist_restore = "bash -c 'sleep 1 && cliphist list | head -n 1 | cliphist decode | wl-copy'",

	waybar = "$HOME/.config/hypr/script/waybar.sh",
	wallpaper_daemon = "awww-daemon",
	wallpaper_cmd = "sleep 1 && awww img $HOME/Pictures/wallpapers/MaiPhuongDangIu.jpg --transition-type center",
}
