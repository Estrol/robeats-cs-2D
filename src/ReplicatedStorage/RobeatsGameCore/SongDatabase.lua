local SPList = require(game.ReplicatedStorage.Shared.SPList)

local Promise = require(game.ReplicatedStorage.Knit.Util.Promise)

local SongMapList = require(workspace.Songs.SongMapList)

-- local SongMaps = workspace:WaitForChild("SongMaps")

local SongDatabase = {}

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

	function self:key_itr()
		return pairs(SongMapList)
	end

	function self:get_data_for_key(key)
		return require(SongMapList[key])
	end

	function self:contains_key(key)
		return SongMapList[key] ~= nil
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
	
	function self:get_image_for_key(key)
		local songdata = self:get_data_for_key(key)
		return songdata.AudioCoverImageAssetId
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

	function self:get_note_metrics_for_key(key)
		local data = self:get_data_for_key(key)
		local total_notes = 0
		local total_holds = 0

		for _, hit_object in pairs(data.HitObjects) do
			if hit_object.Type == 1 then
				total_notes += 1
			elseif hit_object.Type == 2 then
				total_holds += 1
			end
		end

		return total_notes, total_holds
	end

	function self:get_hit_objects_for_key(key)
		local data = self:get_data_for_key(key)
		return data.HitObjects
	end
	
	function self:invalid_songkey() return -1 end

	return self
end

return SongDatabase:new()