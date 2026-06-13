-- default/autostart.lua

hl.on("hyprland.start", function()
	-- 	-- fcitx5
	hl.exec_cmd("export GTK_IM_MODULE=fcitx5")
	hl.exec_cmd("export QT_IM_MODULE=fcitx5")
	hl.exec_cmd("export QT_IM_MODULE=fcitx5")
	hl.exec_cmd("export XMODIFIERS=@im=fcitx5")
	hl.exec_cmd("export INPUT_METHOD=fcitx5")
	hl.exec_cmd("export SDL_IM_MODULE=fcitx5")
	hl.exec_cmd("fcitx5")

	-- Device settings
	hl.exec_cmd("hyprctl keyword 'device[power-button]:enabled' false")

	-- Environment
	hl.exec_cmd("dbus-update-activation-environment --all")

	-- Services
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd("greenclip daemon")

	-- Waybar
	hl.exec_cmd("$HOME/.config/hypr/script/waybar.sh")

	-- Wallpaper
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("sleep 1 && awww img $HOME/Pictures/wallpapers/MaiPhuongDangIu.jpg --transition-type center")
end)
