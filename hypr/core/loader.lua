local M = {}

local function interpolate(str, vars)
	if type(str) ~= "string" then
		return str
	end
	return (str:gsub("{{(.-)}}", function(key)
		return vars[key] or ""
	end))
end

function M.load(profileName)
	local base = require("base")
	local profile = require("profiles." .. profileName)

	return require("core.merge").merge(base, profile)
end

function M.apply(cfg)
	local vars = cfg.variables or {}

	-- 1. Apply options
	if cfg.options then
		if cfg.options.monitor then
			hl.monitor(cfg.options.monitor)
		end
		if cfg.options.config then
			hl.config(cfg.options.config)
		end
		if cfg.options.devices then
			for _, dev in ipairs(cfg.options.devices) do
				hl.device(dev)
			end
		end
	end

	-- 2. Apply rules
	if cfg.rules then
		for _, r in ipairs(cfg.rules.window_rules or {}) do
			hl.window_rule(r)
		end
		for _, r in ipairs(cfg.rules.layer_rules or {}) do
			hl.layer_rule(r)
		end
		for _, r in ipairs(cfg.rules.workspace_rules or {}) do
			hl.workspace_rule(r)
		end
	end

	-- 3. Apply binds
	if cfg.binds and cfg.binds.binds then
		for _, b in pairs(cfg.binds.binds) do
			local key = interpolate(b.key, vars)
			local action_fn
			local args = interpolate(b.args, vars)

			-- Determine action from hl.dsp mapping
			if b.action == "exec_cmd" then
				action_fn = hl.dsp.exec_cmd(args)
			elseif b.action == "window.drag" then
				action_fn = hl.dsp.window.drag()
			elseif b.action == "window.resize" then
				action_fn = hl.dsp.window.resize(b.options)
			elseif b.action == "window.close" then
				action_fn = hl.dsp.window.close()
			elseif b.action == "exit" then
				action_fn = hl.dsp.exit()
			elseif b.action == "window.float" then
				action_fn = hl.dsp.window.float(b.options)
			elseif b.action == "window.fullscreen" then
				action_fn = hl.dsp.window.fullscreen(b.options)
			elseif b.action == "window.pin" then
				action_fn = hl.dsp.window.pin(b.options)
			elseif b.action == "focus" then
				action_fn = hl.dsp.focus(b.options)
			elseif b.action == "window.move" then
				action_fn = hl.dsp.window.move(b.options)
			elseif b.action == "window.center" then
				action_fn = hl.dsp.window.center()
			elseif b.action == "submap" then
				action_fn = hl.dsp.submap(args)
			end

			if action_fn then
				hl.bind(key, action_fn, b.options)
			end
		end
	end

	-- 4. Apply submaps
	if cfg.binds and cfg.binds.submaps then
		for submap_name, submap_binds in pairs(cfg.binds.submaps) do
			hl.define_submap(submap_name, function()
				for _, b in pairs(submap_binds) do
					local key = interpolate(b.key, vars)
					local args = interpolate(b.args, vars)
					local action_fn
					if b.action == "exec_cmd" then
						action_fn = hl.dsp.exec_cmd(args)
					elseif b.action == "window.resize" then
						action_fn = hl.dsp.window.resize(b.options)
					elseif b.action == "submap" then
						action_fn = hl.dsp.submap(args)
					end

					if action_fn then
						hl.bind(key, action_fn, b.options)
					end
				end
			end)
		end
	end

	-- 5. Apply autostart
	if cfg.autostart then
		hl.on("hyprland.start", function()
			for _, cmd in pairs(cfg.autostart) do
				if cmd and cmd ~= "" then
					hl.exec_cmd(cmd)
				end
			end
		end)
	end
end

return M
