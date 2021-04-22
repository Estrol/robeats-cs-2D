local SPList = require(game.ReplicatedStorage.Shared.SPList)
local SongErrorParser = require(game.ReplicatedStorage.RobeatsGameCore.SongErrorParser)

local SongMetadata = require(workspace:WaitForChild("Songs"):WaitForChild("SongMetadata"))

local SongDatabase = {}

SongDatabase.SongStatus = {
	RANKED = "RANKED";
	UNRANKED = "UNRANKED";
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

	local _all_keys = SongMetadata

	function self:key_itr()
		return ipairs(_all_keys)
	end

	function self:get_data_for_key(key)
		return _all_keys[key]
	end

	function self:contains_key(key)
		return _all_keys[key] ~= nil
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

	function self:get_image_for_key(key)
		local songdata = self:get_data_for_key(key)
		if songdata.AudioCoverImageAssetId ~= "" then
			return songdata.AudioCoverImageAssetId
		else
			return "rbxassetid://2832671181"
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
		local hit_objects = self:get_hit_objects_for_key(key)
		local last_hit_ob = hit_objects[#hit_objects]

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

			return table.concat(_search_data, " "):lower()
		end
		return ""
	end

	function self:filter_keys(str)
		local ret = {}

		for key in self:key_itr() do
			if not str or str == "" then
				table.insert(ret, key)
			else
				local search_str = self:get_search_string_for_key(key)
				if string.find(search_str, str:lower()) ~= nil then
					table.insert(ret, key)
				end
			end
		end

		return ret
	end

	function self:get_hit_objects_for_key(key)
		local data = self:get_data_for_key(key)
		return require(data.AudioMapData)
	end

	function self:get_note_metrics_for_key(key)
		local total_notes = 0
		local total_holds = 0

		for _, hit_object in pairs(self:get_hit_objects_for_key(key)) do
			if hit_object.Type == 1 then
				total_notes += 1
			elseif hit_object.Type == 2 then
				total_holds += 1
			end
		end

		return total_notes, total_holds
	end
	
	function self:invalid_songkey() return -1 end

	return self
end

return SongDatabase:new()