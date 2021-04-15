local SPList = require(game.ReplicatedStorage.Shared.SPList)
local SPDict = require(game.ReplicatedStorage.Shared.SPDict)
local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)
local TryRequire = require(game.ReplicatedStorage.Shared.TryRequire)
local SongErrorParser = require(game.ReplicatedStorage.RobeatsGameCore.SongErrorParser)

local Remotes = require(game.ReplicatedStorage.Remotes)

local Promise = require(game.ReplicatedStorage.Packages.Promise)

local DebugOut = require(game.ReplicatedStorage.Shared.DebugOut)

-- local SongMapList = string.split(game.Workspace.SongMapList.Value, "\n")

-- local SongMaps = workspace:WaitForChild("SongMaps")

local SongDatabase = {}

local invalid_require_error_message = [[
	There is an error in one of the song modules!
	Usually this is caused by a wacky require call in the module (this should never happen), or because there is no return statement at the end of the song module (song modules should end with "return rtv").

	If there is still an issue please contact one of the game's maintainers.

	Stack trace:

	%s
]]

SongDatabase.SongMode = {
	Normal = 0;
	SupporterOnly = 1;
}

SongDatabase.SongType = {
	Normal = 0;
	Light = 1;
	Heavy = 2;
	Extra = 3;
}

function SongDatabase:new()
	local self = {}
	self.SongMode = SongDatabase.SongMode

	local _all_keys = SPList:new()

	local _get_maps
	local _get_hit_data

	function self:cons()

		_get_maps = Remotes.Client:Get("GetMaps")
		_get_hit_data = Remotes.Client:Get("GetHitData")
		local succeeded, maps = _get_maps:CallServerAsync():await()

		if not succeeded then
			error("Oh no! Something went wrong when trying to get the map data.")
		end

		for _, map in ipairs(maps) do
			-- SongErrorParser:scan_audiodata_for_errors(audio_data)

			_all_keys:push_back(map)
		end
	end

	function self:key_itr()
		return ipairs(_all_keys._table)
	end

	function self:get_data_for_key(key)
		return _all_keys:get(key)
	end

	function self:contains_key(key)
		return _all_keys:get(key) ~= nil
	end

	function self:key_get_audiomod(key)
		local data = self:get_data_for_key(key)
		if data.AudioMod == 1 then
			return SongDatabase.SongMode.SupporterOnly
		end
		return SongDatabase.SongMode.Normal
	end

	function self:render_coverimage_for_key(cover_image, overlay_image, key)
		local songdata = self:get_data_for_key(key)
		cover_image.Image = songdata.AudioCoverImageAssetId

		if overlay_image then
			local audiomod = self:key_get_audiomod(key)
			if audiomod == SongDatabase.SongMode.SupporterOnly then
				overlay_image.Image = "rbxassetid://837274453"
				overlay_image.Visible = true
			else
				overlay_image.Visible = false
			end
		end
	end

	function self:get_title_for_key(key)
		local songdata = self:get_data_for_key(key)
		return songdata.AudioFilename
	end

	function self:get_artist_for_key(key)
		local songdata = self:get_data_for_key(key)
		return songdata.AudioArtist
	end

	function self:get_difficulty_for_key(key)
		local songdata = self:get_data_for_key(key)
		return songdata.AudioDifficulty
	end

	function self:get_description_for_key(key)
		local songdata = self:get_data_for_key(key)
		return songdata.AudioDescription
	end

	function self:get_song_length_for_key(key)
		local data = self:get_data_for_key(key)
		local last_hit_ob = data.HitObjects[#data.HitObjects]

		return last_hit_ob.Time + (last_hit_ob.Duration or 0)
	end

	function self:get_song_type_for_key(key)
		--hey regen leave this method empty, i'll keep workin on it - astral
		return
	end

	function self:get_search_string_for_key(key)
		local data = self:get_data_for_key(key)
		if data ~= nil then
			local _search_data = {
				data.AudioArtist,
				data.AudioFilename,
				data.AudioDifficulty
			}

			return table.concat(_search_data, " ")
		end
		return ""
	end

	function self:get_hit_objects_for_key(key)
		local data = self:get_data_for_key(key)
		return Promise.new(function(resolve, reject)
			if data.HitObjects then
				resolve(data.HitObjects)
				return
			end
			resolve(_get_hit_data:CallServerAsync(data._id))
		end)
	end
	
	function self:invalid_songkey() return -1 end

	self:cons()
	return self
end

return SongDatabase:new()