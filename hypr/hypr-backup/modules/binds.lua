-- modules/bind.lua

local mainMod = "SUPER"
local altMod = "ALT"

local terminal = "kitty"
local fileManager = "thunar"
local browser = "brave --password-store=basic"
local menu = "rofi -show drun"

local waybarToggle = "~/.config/waybar/script/toggle.sh"
local wallpaperSelector = "~/.config/hypr/script/wallpaper_selector.sh"
local lockscreen = "~/.config/hypr/script/lockscreen.sh"
local clipboard = "~/.config/hypr/script/clipboard.sh | wl-copy"

------------------
-- BINDS: CORE
------------------
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(waybarToggle))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("kitty nvim"))
hl.bind(altMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind(altMod .. " + W", hl.dsp.exec_cmd(wallpaperSelector))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipboard))

hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + Y", hl.dsp.window.pin({ action = "toggle" }))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("hyprpicker -a"))

hl.bind("F3", hl.dsp.exec_cmd([[hyprctl keyword 'device[pnp0c50:0e-06cb:7e7e-touchpad]:enabled' true]]))
hl.bind("F4", hl.dsp.exec_cmd([[hyprctl keyword 'device[pnp0c50:0e-06cb:7e7e-touchpad]:enabled' false]]))
hl.bind(altMod .. " + SHIFT + L", hl.dsp.exec_cmd(lockscreen))

------------------
-- BINDS: FOCUS / MOVE
------------------
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))

hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

hl.bind(mainMod .. " + bracketleft", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + bracketright", hl.dsp.focus({ workspace = "e+1" }))

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

	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
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

hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot fullscreen file"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("hyprshot region file"))
hl.bind(mainMod .. " + CTRL + Print", hl.dsp.exec_cmd("hyprshot window file"))

hl.bind(altMod .. " + SHIFT + Print", hl.dsp.exec_cmd("hyprshot region clipboard preview"))
hl.bind(altMod .. " + CTRL + Print", hl.dsp.exec_cmd("hyprshot window clipboard preview"))

------------------
-- BINDS: RECORD / CENTER
------------------
hl.bind(
	mainMod .. " + F10",
	hl.dsp.exec_cmd(
		[[kitty --class warm-record-mode --title warm-record-mode bash -lc "$HOME/.config/hypr/script/warm-record-mode.sh"]]
	)
)
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.center())

------------------
-- SUBMAP: OPEN MODE
------------------
hl.bind(mainMod .. " + O", hl.dsp.submap("open"))

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
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))

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
