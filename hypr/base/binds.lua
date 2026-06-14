local function gen_workspace_binds()
	local ws = {}
	for i = 1, 10 do
		local key = tostring(i % 10)
		local workspace = tostring(i)
		ws["workspace_" .. workspace] =
			{ key = "{{mainMod}} + " .. key, action = "focus", args = { workspace = workspace } }
		ws["move_workspace_" .. workspace] =
			{ key = "{{mainMod}} + SHIFT + " .. key, action = "window.move", args = { workspace = workspace } }
	end
	return ws
end

local binds = {
	drag = { key = "{{mainMod}} + mouse:272", action = "window.drag", options = { mouse = true } },
	resize_mouse = { key = "{{mainMod}} + mouse:273", action = "window.resize", options = { mouse = true } },

	terminal = { key = "{{mainMod}} + Return", action = "exec_cmd", args = "{{terminal.cmd}}" },
	close = { key = "{{mainMod}} + Q", action = "window.close" },
	exit = { key = "{{mainMod}} + M", action = "exit" },
	fileManager = { key = "{{mainMod}} + E", action = "exec_cmd", args = "{{fileManager.cmd}}" },
	browser = { key = "{{mainMod}} + B", action = "exec_cmd", args = "{{browser.cmd}}" },
	waybarToggle = { key = "{{mainMod}} + W", action = "exec_cmd", args = "{{waybar.toggle}}" },
	editor = { key = "{{mainMod}} + N", action = "exec_cmd", args = "kitty nvim" },
	menu = { key = "{{altMod}} + Space", action = "exec_cmd", args = "{{menu.cmd}}" },
	wallpaperSelector = { key = "{{altMod}} + W", action = "exec_cmd", args = "{{wallpaper.selector}}" },
	clipboard = { key = "{{mainMod}} + V", action = "exec_cmd", args = "{{clipboard.cmd}}" },

	float = { key = "{{mainMod}} + T", action = "window.float", args = { action = "toggle" } },
	fullscreen = {
		key = "{{mainMod}} + F",
		action = "window.fullscreen",
		args = { mode = "fullscreen", action = "toggle" },
	},
	pin = { key = "{{mainMod}} + Y", action = "window.pin", args = { action = "toggle" } },
	colorpicker = { key = "{{mainMod}} + C", action = "exec_cmd", args = "hyprpicker -a" },

	touchpad_enable = {
		key = "F3",
		action = "exec_cmd",
		args = [[hyprctl eval 'hl.device({ name = "pnp0c50:0e-06cb:7e7e-touchpad", enabled = true })']],
	},
	touchpad_disable = {
		key = "F4",
		action = "exec_cmd",
		args = [[hyprctl eval 'hl.device({ name = "pnp0c50:0e-06cb:7e7e-touchpad", enabled = false })']],
	},
	lockscreen = { key = "{{altMod}} + SHIFT + L", action = "exec_cmd", args = "{{lockscreen.cmd}}" },

	focus_l = { key = "{{mainMod}} + H", action = "focus", args = { direction = "left" } },
	focus_d = { key = "{{mainMod}} + J", action = "focus", args = { direction = "down" } },
	focus_u = { key = "{{mainMod}} + K", action = "focus", args = { direction = "up" } },
	focus_r = { key = "{{mainMod}} + L", action = "focus", args = { direction = "right" } },

	move_l = { key = "{{mainMod}} + SHIFT + H", action = "window.move", args = { direction = "left" } },
	move_d = { key = "{{mainMod}} + SHIFT + J", action = "window.move", args = { direction = "down" } },
	move_u = { key = "{{mainMod}} + SHIFT + K", action = "window.move", args = { direction = "up" } },
	move_r = { key = "{{mainMod}} + SHIFT + L", action = "window.move", args = { direction = "right" } },

	workspace_prev = { key = "{{mainMod}} + bracketleft", action = "focus", args = { workspace = "e-1" } },
	workspace_next = { key = "{{mainMod}} + bracketright", action = "focus", args = { workspace = "e+1" } },

	volume_up = {
		key = "XF86AudioRaiseVolume",
		action = "exec_cmd",
		args = "pactl set-sink-volume @DEFAULT_SINK@ +5%",
		options = { repeating = true },
	},
	volume_down = {
		key = "XF86AudioLowerVolume",
		action = "exec_cmd",
		args = "pactl set-sink-volume @DEFAULT_SINK@ -5%",
		options = { repeating = true },
	},
	volume_mute = { key = "XF86AudioMute", action = "exec_cmd", args = "pactl set-sink-mute @DEFAULT_SINK@ toggle" },
	brightness_up = {
		key = "XF86MonBrightnessUp",
		action = "exec_cmd",
		args = "brightnessctl set +10%",
		options = { repeating = true },
	},
	brightness_down = {
		key = "XF86MonBrightnessDown",
		action = "exec_cmd",
		args = "brightnessctl set 10%-",
		options = { repeating = true },
	},

	screenshot_full_clip = { key = "Print", action = "exec_cmd", args = "hyprshot fullscreen clipboard" },
	screenshot_region_clip = { key = "SHIFT + Print", action = "exec_cmd", args = "hyprshot region clipboard" },
	screenshot_window_clip = { key = "CTRL + Print", action = "exec_cmd", args = "hyprshot window clipboard" },

	screenshot_full_file = { key = "{{mainMod}} + Print", action = "exec_cmd", args = "hyprshot fullscreen file" },
	screenshot_region_file = { key = "{{mainMod}} + SHIFT + Print", action = "exec_cmd", args = "hyprshot region file" },
	screenshot_window_file = { key = "{{mainMod}} + CTRL + Print", action = "exec_cmd", args = "hyprshot window file" },

	screenshot_region_preview = {
		key = "{{altMod}} + SHIFT + Print",
		action = "exec_cmd",
		args = "hyprshot region clipboard preview",
	},
	screenshot_window_preview = {
		key = "{{altMod}} + CTRL + Print",
		action = "exec_cmd",
		args = "hyprshot window clipboard preview",
	},

	record_mode = {
		key = "{{mainMod}} + F10",
		action = "exec_cmd",
		args = [[kitty --class warm-record-mode --title warm-record-mode bash -lc "$HOME/.config/hypr/script/warm-record-mode.sh"]],
	},
	center = { key = "{{mainMod}} + SHIFT + C", action = "window.center" },

	submap_open = { key = "{{mainMod}} + O", action = "submap", args = "open" },
	submap_resize = { key = "{{mainMod}} + R", action = "submap", args = "resize" },
}

local submaps = {
	open = {
		steam = { key = "S", action = "exec_cmd", args = [[sh -c "steam & hyprctl dispatch submap reset"]] },
		discord = { key = "D", action = "exec_cmd", args = [[sh -c "discord & hyprctl dispatch submap reset"]] },
		obs = { key = "O", action = "exec_cmd", args = [[sh -c "obs & hyprctl dispatch submap reset"]] },
		zalo = { key = "Z", action = "exec_cmd", args = [[sh -c "zalo & hyprctl dispatch submap reset"]] },
		lark = { key = "L", action = "exec_cmd", args = [[sh -c "lark & hyprctl dispatch submap reset"]] },
		escape = { key = "escape", action = "submap", args = "reset" },
		return_key = { key = "return", action = "submap", args = "reset" },
		catchall = { key = "catchall", action = "submap", args = "reset" },
	},
	resize = {
		resize_l = {
			key = "h",
			action = "window.resize",
			args = { x = -10, y = 0, relative = true },
			options = { repeating = true },
		},
		resize_r = {
			key = "l",
			action = "window.resize",
			args = { x = 10, y = 0, relative = true },
			options = { repeating = true },
		},
		resize_u = {
			key = "k",
			action = "window.resize",
			args = { x = 0, y = -10, relative = true },
			options = { repeating = true },
		},
		resize_d = {
			key = "j",
			action = "window.resize",
			args = { x = 0, y = 10, relative = true },
			options = { repeating = true },
		},

		resize_L = {
			key = "SHIFT + h",
			action = "window.resize",
			args = { x = -50, y = 0, relative = true },
			options = { repeating = true },
		},
		resize_R = {
			key = "SHIFT + l",
			action = "window.resize",
			args = { x = 50, y = 0, relative = true },
			options = { repeating = true },
		},
		resize_U = {
			key = "SHIFT + k",
			action = "window.resize",
			args = { x = 0, y = -50, relative = true },
			options = { repeating = true },
		},
		resize_D = {
			key = "SHIFT + j",
			action = "window.resize",
			args = { x = 0, y = 50, relative = true },
			options = { repeating = true },
		},

		escape = { key = "escape", action = "submap", args = "reset" },
		return_key = { key = "return", action = "submap", args = "reset" },
	},
}

for k, v in pairs(gen_workspace_binds()) do
	binds[k] = v
end

return {
	binds = binds,
	submaps = submaps,
}
