local merge = require("core.merge").merge

return {
	variables = require("base.variables"),
	autostart = require("base.autostart"),
	binds = require("base.binds"),
	options = merge(require("base.options"), require("base.animations")),
	rules = require("base.rules"),
}
