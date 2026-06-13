-- modules/autostart.lua
local currentProfile = require("current_profile")
local vars = require("profiles." .. currentProfile .. ".variables")

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
	hl.exec_cmd(vars.waybarStart)

	-- Wallpaper
	hl.exec_cmd(vars.wallpaperDaemon)
	hl.exec_cmd(vars.wallpaperCmd)
end)
