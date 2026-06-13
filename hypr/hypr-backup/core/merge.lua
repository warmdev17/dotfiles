local M = {}

function M.merge(base, override)
	local result = {}

	-- copy base
	for k, v in pairs(base or {}) do
		if type(v) == "table" then
			result[k] = M.merge(v, {})
		else
			result[k] = v
		end
	end

	-- apply override
	for k, v in pairs(override or {}) do
		if type(v) == "table" and type(result[k]) == "table" then
			result[k] = M.merge(result[k], v)
		else
			result[k] = v
		end
	end

	return result
end

return M
