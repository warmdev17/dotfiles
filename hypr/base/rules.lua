local workspace_rules = {}
for i = 1, 10 do
	table.insert(workspace_rules, {
		workspace = i,
		monitor = "eDP-1",
	})
end

return {
	window_rules = {
		{
			match = { class = "feh-preview" },
			float = true,
			center = true,
			rounding = 0,
			opacity = "1 1",
			border_color = { colors = { "rgb(89b4fa)", "rgb(89b4fa)" } },
		},
		{
			match = { class = "xdg-desktop-portal-gtk" },
			float = true,
			center = true,
		},
		{
			match = { class = "Emulator" },
			float = true,
			no_blur = false,
			border_size = 0,
			opacity = "1.0 1.0",
		},
		{
			match = { class = "warm-record-mode" },
			size = { 1000, 560 },
			float = true,
			center = true,
			rounding = 10,
			opacity = "1 1",
			border_color = { colors = { "rgb(89b4fa)", "rgb(89b4fa)" } },
		},
	},

	layer_rules = {
		{ match = { namespace = "waybar" }, blur = true },
		{ match = { namespace = "swaync" }, blur = true },
		{ match = { namespace = "rofi" }, blur = true },
		{ match = { namespace = "waybar" }, xray = false, ignore_alpha = 0 },
		{ name = "no_anim_for_selection", match = { namespace = "selection" }, no_anim = true },
	},

	workspace_rules = workspace_rules,
}
