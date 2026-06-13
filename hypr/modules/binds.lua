-- modules/bind.lua

local currentProfile = require("current_profile")
local vars = require("profiles." .. currentProfile .. ".variables")

------------------
-- BINDS: CORE
------------------
hl.bind(vars.mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(vars.mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(vars.mainMod .. " + Return", hl.dsp.exec_cmd(vars.terminal))
hl.bind(vars.mainMod .. " + Q", hl.dsp.window.close())
hl.bind(vars.mainMod .. " + M", hl.dsp.exit())
hl.bind(vars.mainMod .. " + E", hl.dsp.exec_cmd(vars.fileManager))
hl.bind(vars.mainMod .. " + B", hl.dsp.exec_cmd(vars.browser))
hl.bind(vars.mainMod .. " + W", hl.dsp.exec_cmd(vars.waybarToggle))
hl.bind(vars.mainMod .. " + N", hl.dsp.exec_cmd("kitty nvim"))
hl.bind(vars.altMod .. " + Space", hl.dsp.exec_cmd(vars.menu))
hl.bind(vars.altMod .. " + W", hl.dsp.exec_cmd(vars.wallpaperSelector))
hl.bind(vars.mainMod .. " + V", hl.dsp.exec_cmd(vars.clipboard))

hl.bind(vars.mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(vars.mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(vars.mainMod .. " + Y", hl.dsp.window.pin({ action = "toggle" }))
hl.bind(vars.mainMod .. " + C", hl.dsp.exec_cmd("hyprpicker -a"))

hl.bind("F3", hl.dsp.exec_cmd([[hyprctl keyword 'device[pnp0c50:0e-06cb:7e7e-touchpad]:enabled' true]]))
hl.bind("F4", hl.dsp.exec_cmd([[hyprctl keyword 'device[pnp0c50:0e-06cb:7e7e-touchpad]:enabled' false]]))
hl.bind(vars.altMod .. " + SHIFT + L", hl.dsp.exec_cmd(vars.lockscreen))

------------------
-- BINDS: FOCUS / MOVE
------------------
hl.bind(vars.mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(vars.mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(vars.mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(vars.mainMod .. " + L", hl.dsp.focus({ direction = "r" }))

hl.bind(vars.mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(vars.mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(vars.mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(vars.mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

hl.bind(vars.mainMod .. " + bracketleft", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(vars.mainMod .. " + bracketright", hl.dsp.focus({ workspace = "e+1" }))

------------------
-- BINDS: Toggle device
------------------
hl.bind(
	"F3",
	hl.dsp.exec_cmd([[
hyprctl eval '
hl.device({
    name = "pnp0c50:0e-06cb:7e7e-touchpad",
    enabled = true,
})
'
]])
)

hl.bind(
	"F4",
	hl.dsp.exec_cmd([[
hyprctl eval '
hl.device({
    name = "pnp0c50:0e-06cb:7e7e-touchpad",
    enabled = false,
})
'
]])
)

------------------
-- BINDS: WORKSPACES
------------------
for i = 1, 10 do
	local key = tostring(i % 10)
	local workspace = tostring(i)

	hl.bind(vars.mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
	hl.bind(vars.mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

------------------
-- BINDS: AUDIO / BRIGHTNESS
------------------
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +10%"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { repeating = true })

------------------
-- BINDS: SCREENSHOT
------------------
hl.bind("Print", hl.dsp.exec_cmd("hyprshot fullscreen clipboard"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot region clipboard"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd("hyprshot window clipboard"))

hl.bind(vars.mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot fullscreen file"))
hl.bind(vars.mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("hyprshot region file"))
hl.bind(vars.mainMod .. " + CTRL + Print", hl.dsp.exec_cmd("hyprshot window file"))

hl.bind(vars.altMod .. " + SHIFT + Print", hl.dsp.exec_cmd("hyprshot region clipboard preview"))
hl.bind(vars.altMod .. " + CTRL + Print", hl.dsp.exec_cmd("hyprshot window clipboard preview"))

------------------
-- BINDS: RECORD / CENTER
------------------
hl.bind(
	vars.mainMod .. " + F10",
	hl.dsp.exec_cmd(
		[[kitty --class warm-record-mode --title warm-record-mode bash -lc "$HOME/.config/hypr/script/warm-record-mode.sh"]]
	)
)
hl.bind(vars.mainMod .. " + SHIFT + C", hl.dsp.window.center())

------------------
-- SUBMAP: OPEN MODE
------------------
hl.bind(vars.mainMod .. " + O", hl.dsp.submap("open"))

hl.define_submap("open", function()
	hl.bind("S", hl.dsp.exec_cmd([[sh -c "steam & hyprctl dispatch submap reset"]]))
	hl.bind("D", hl.dsp.exec_cmd([[sh -c "discord & hyprctl dispatch submap reset"]]))
	hl.bind("O", hl.dsp.exec_cmd([[sh -c "obs & hyprctl dispatch submap reset"]]))
	hl.bind("Z", hl.dsp.exec_cmd([[sh -c "zalo & hyprctl dispatch submap reset"]]))
	hl.bind("L", hl.dsp.exec_cmd([[sh -c "lark & hyprctl dispatch submap reset"]]))
	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("return", hl.dsp.submap("reset"))
	hl.bind("catchall", hl.dsp.submap("reset"))
end)

------------------
-- SUBMAP: RESIZE MODE
------------------
hl.bind(vars.mainMod .. " + R", hl.dsp.submap("resize"))

hl.define_submap("resize", function()
	hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
	hl.bind("l", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
	hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
	hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })

	hl.bind("SHIFT + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
	hl.bind("SHIFT + k", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
	hl.bind("SHIFT + j", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

	hl.bind("escape", hl.dsp.submap("reset"))
	hl.bind("return", hl.dsp.submap("reset"))
end)
