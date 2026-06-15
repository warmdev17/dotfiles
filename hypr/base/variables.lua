return {
	mainMod = "SUPER",
	altMod = "ALT",

	terminal = { cmd = "kitty" },
	fileManager = { cmd = "thunar" },
	browser = { cmd = "brave --password-store=basic" },
	menu = { cmd = "rofi -show drun" },

	waybar = {
		toggle = "~/.config/waybar/script/toggle.sh",
	},
	wallpaper = {
		selector = "~/.config/hypr/script/wallpaper_selector.sh",
	},

	lockscreen = { cmd = "~/.config/hypr/script/lockscreen.sh" },
	clipboard = { cmd = "~/.config/hypr/script/clipboard.sh | wl-copy" },
	toggleProfile = { cmd = "~/.config/hypr/script/toggle-profile.sh" },
}
