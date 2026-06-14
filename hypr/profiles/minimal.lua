return {
	variables = {
		browser = { cmd = "brave --password-store=basic" },
		menu = { cmd = "rofi -show drun" },
		terminal = { cmd = "kitty --config /home/warmdev/.config/kitty/minimal.conf" },
		waybar = {
			toggle = "/home/warmdev/.config/waybar/script/toggle_minimal.sh",
			config = "/home/warmdev/.config/waybar/profiles/minimal/config.jsonc",
			style = "/home/warmdev/.config/waybar/profiles/minimal/style.css",
		},
		wallpaper = { selector = "" },
	},

	autostart = {
		waybar = "waybar",
		wallpaper_daemon = "awww-daemon",
		wallpaper_cmd = "sleep 1 && awww img $HOME/Pictures/wallpapers/solid-color-image.png --transition-type center",
	},

	-- 3. EXEC (Runs on EVERY reload / profile switch)
	-- Use this if you want something to change IMMEDIATELY when you switch to this profile.
	-- For example, to change the wallpaper instantly:
	exec = {
		-- When switching to this profile, instantly change the wallpaper:
		wallpaper_change = "awww img $HOME/Pictures/wallpapers/solid-color-image.png --transition-type center",

		-- Kill the old Waybar and spawn a new one with the profile's config and style:
		waybar_reload = "pkill waybar; sleep 0.1; waybar -c {{waybar.config}} -s {{waybar.style}} &",
	},
	options = {
		config = {
			animations = {
				enabled = false,
			},
			general = {
				gaps_in = 0,
				gaps_out = 0,
				border_size = 1,
			},
			decoration = {
				rounding = 0,
			},
		},
	},
}
