return {
	monitor = {
		output = "eDP-1",
		mode = "preferred",
		position = "0x0",
		scale = 1,
	},

	config = {
		input = {
			kb_layout = "us",
			kb_options = "ctrl:nocaps",
			follow_mouse = 1,

			touchpad = {
				natural_scroll = false,
				disable_while_typing = false,
			},

			sensitivity = 0.5,
		},

		general = {
			gaps_in = 5,
			gaps_out = 12,
			border_size = 2,

			["col.active_border"] = "rgb(89b4fa)",
			["col.inactive_border"] = "rgb(6c7086)",

			layout = "dwindle",
		},

		decoration = {
			rounding = 6,

			active_opacity = 1,
			inactive_opacity = 1,

			blur = {
				enabled = true,
				size = 4,
				passes = 2,
				ignore_opacity = true,
				new_optimizations = true,
			},

			shadow = {
				enabled = true,
				range = 4,
				render_power = 3,
				color = "rgba(1a1a1aee)",
			},
		},
	},

	devices = {
		{
			name = "at-translated-set-2-keyboard",
			enabled = false,
		},
		{
			name = "pnp0c50:0e-06cb:7e7e-touchpad",
			enabled = true,
		},
		{
			name = "power-button",
			enabled = false,
		},
	},
}
