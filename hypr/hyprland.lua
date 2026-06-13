local config = require("current_profile")
local loader = require("core.loader")

-- current_profile.lua returns the profile string directly
local profileName = config
local finalConfig = loader.load(profileName)

loader.apply(finalConfig)
