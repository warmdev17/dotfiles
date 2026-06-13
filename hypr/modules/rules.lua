-- feh-preview
hl.window_rule({
	match = {
		class = "feh-preview",
	},
	float = true,
	center = true,
	rounding = 0,
	opacity = "1 1",
	border_color = {
		colors = {
			"rgb(89b4fa)",
			"rgb(89b4fa)",
		},
	},
})

-- Emulator
hl.window_rule({
	match = {
		class = "Emulator",
	},
	float = true,
	no_blur = false,
	border_size = 0,
	opacity = "1.0 1.0",
})

-- warm-record-mode
hl.window_rule({
	match = {
		class = "warm-record-mode",
	},
	size = { 1000, 560 },
	float = true,
	center = true,
	rounding = 10,
	opacity = "1 1",
	border_color = {
		colors = {
			"rgb(89b4fa)",
			"rgb(89b4fa)",
		},
	},
})

-- Layer rules
hl.layer_rule({
	match = {
		namespace = "waybar",
	},
	blur = true,
})

hl.layer_rule({
	match = {
		namespace = "swaync",
	},
	blur = true,
})

hl.layer_rule({
	match = {
		namespace = "rofi",
	},
	blur = true,
})

hl.layer_rule({
	match = {
		namespace = "waybar",
	},
	xray = false,
	ignore_alpha = 0,
})

hl.layer_rule({
	name = "no_anim_for_selection",
	match = {
		namespace = "selection",
	},
	no_anim = true,
})

-- Workspace rules
for i = 1, 10 do
	hl.workspace_rule({
		workspace = i,
		monitor = "eDP-1",
	})
end
