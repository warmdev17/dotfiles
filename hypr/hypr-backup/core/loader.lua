local M = {}

function M.load(profileName)
	local base = require("base")
	local profile = require("profiles." .. profileName)

	return require("core.merge")(base, profile)
end

function M.apply(cfg)
	-- generate hyprland config or call hyprctl reload logic
end

return M
