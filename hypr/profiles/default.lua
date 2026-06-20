return {
	-- =========================================================================
	-- PROFILE OVERRIDE GUIDE
	-- =========================================================================
	-- This table represents your "Profile", which is deeply merged with the
	-- "Base" configuration located in `base/init.lua` and other `base/` files.
	--
	-- How merging works:
	-- 1. Any key defined here will OVERRIDE the corresponding key in `base`.
	-- 2. New keys added here will be ADDED to the base configuration.
	-- 3. Arrays (like autostart or window_rules) are overwritten if you specify
	--    them here, or you can append by defining new items at higher indexes.
	-- =========================================================================

	-- 1. OVERRIDING VARIABLES
	-- Variables are evaluated using `{{varName}}` inside your bindings.
	-- If you change a variable here, any base binding that uses it will
	-- automatically use the new value.
	variables = {
		-- Example: Override the terminal to use alacritty instead of kitty
		-- terminal = { cmd = "alacritty" },

		-- Example: Override the rofi theme for this profile
		-- menu = { cmd = "rofi -show drun -theme ~/.config/rofi/my_theme.rasi" },
	},

	-- 2. OVERRIDING AUTOSTART (Runs ONLY on startup)
	-- To add new startup commands or override base ones, just declare them.
	autostart = {
		-- Base config already starts waybar, swaybg, etc. (Index 1..5)
		-- You can add profile-specific autostarts:
		-- "dex -a -s /etc/xdg/autostart/",
		-- "nm-applet --indicator",
	},

	-- 3. EXEC (Runs on EVERY reload / profile switch)
	-- Use this if you want something to change IMMEDIATELY when you switch to this profile.
	-- For example, to change the wallpaper instantly:
	exec = {
		-- Instantly change to the default wallpaper when switching to this profile:
		wallpaper_change = "awww img $HOME/Pictures/wallpapers/MaiPhuongDangIu.jpg --transition-type center",
		waybar_reload = "pkill waybar; sleep 0.1; waybar &",
	},

	-- 4. OVERRIDING HYPRLAND OPTIONS
	-- You can modify animations, decorators, or general settings.
	options = {
		-- Example: disable animations for a minimal profile
		-- animations = { enabled = false },

		-- Example: change border colors
		-- general = {
		--     ["col.active_border"] = "rgba(ff0000ff)",
		-- },

		-- Example: enable/disable specific devices (e.g. keyboards, touchpads)
		-- To find the exact name of your device, run `hyprctl devices` in your terminal.
		-- devices = {
		--     {
		--         name = "my-device-name",
		--         enabled = false,
		--     },
		-- },
	},

	-- 5. OVERRIDING OR ADDING KEYBINDS
	-- You can redefine a base keybind by using its EXACT name (e.g., `terminal`),
	-- or add a completely new one.
	binds = {
		binds = {
			-- Example: Override the `terminal` bind to use SUPER + Enter
			-- terminal = { key = "{{mainMod}} + Return", action = "exec_cmd", args = "{{terminal}}" },

			-- Example: Add a brand new binding specific to this profile
			-- my_script = { key = "{{mainMod}} + SHIFT + P", action = "exec_cmd", args = "~/myscript.sh" },
		},
		-- Submaps can be overridden the same way!
		-- submaps = { ... }
	},

	-- 6. OVERRIDING RULES
	-- Modify window rules or workspace rules
	rules = {
		-- window_rules = {
		--     { match = { class = "firefox" }, rules = { "opacity 0.9" } }
		-- }
	},
}
