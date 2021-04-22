local DatastoreSerializer = require(game.ReplicatedStorage.Serialization.Datastore)
local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)
local Signal = require(game.ReplicatedStorage.Knit.Util.Signal)
local DebugOut = require(game.ReplicatedStorage.Shared.DebugOut)

--[[
Use this class to access player settings. Example:
local Configuration = require(game.ReplicatedStorage.Configuration)
print(Configuration.Preferences.NoteSpeedMultiplier) --To access player NoteSpeedMultiplier
]]--

local Configuration = {
	Preferences = SPUtil:copy_table(require(game.ReplicatedStorage.DefaultSettings))
}

Configuration.Changed = Signal.new()

function Configuration:set(path, value)
	local ptr = self.Preferences

	for i = 1, #path - 1 do
		if ptr == nil then
			DebugOut:errf("Invalid directory %s", table.concat(path, "/"))
		end

		local path_dir = path[i]
		ptr = ptr[path_dir]
	end

	if typeof(value) == "function" then
		ptr[path[#path]] = value(ptr[path[#path]])
	else
		ptr[path[#path]] = value
	end

	self.Changed:Fire(self.Preferences)
end

function Configuration:load_from_save()
	local suc, err = pcall(function()
			-- local settings = Network.("RetrieveSettings")
			-- local deserialized = DatastoreSerializer:deserialize_table(settings or {})
			-- if settings ~= nil then
			-- 		for i, v in pairs(deserialized) do
			-- 				self.Preferences[i] = v
			-- 		end
			-- end
	end)
	
	if not suc then
			warn(err)
	end
end

return Configuration