return {
	variables = {
		browser = "brave",
		menu = "rofi -show run",
		waybarToggle = "pkill waybar || waybar",
		wallpaperSelector = "",
	},

	autostart = {
		waybar = "waybar",
		wallpaper_daemon = "swaybg",
		wallpaper_cmd = "swaybg -c '#000000'",
	},

	options = {
		config = {
			animations = {
				enabled = false,
			},
		},
	},
}
