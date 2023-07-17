local HttpService = game:GetService("HttpService")
local ServerScriptService = game:GetService("ServerScriptService")

local SPDict = require(game.ReplicatedStorage.Shared.SPDict)
local SongErrorParser = require(game.ReplicatedStorage.RobeatsGameCore.SongErrorParser)

local SongMetadata = require(workspace:WaitForChild("Songs"):WaitForChild("SongMetadata"))

local SongDatabase = {}

SongDatabase.SongStatus = {
	RANKED = "RANKED";
	UNRANKED = "UNRANKED";
}

function SongDatabase:new()
	local self = {}
	self.SongMode = SongDatabase.SongMode

	local _all_keys = SongMetadata
	local _map_data_cache = SPDict:new()

	function self:cons()
		for itr_key, data in self:key_itr() do
			data.SongKey = itr_key
		end
	end

	function self:key_itr()
		return ipairs(_all_keys)
	end

	function self:get_key_count()
		return #_all_keys
	end

	function self:get_glicko_estimate_from_rating(rating)
		return 0.55 * rating * rating + 500
	end

	function self:get_data_for_key(key)
		local data = _all_keys[key]

		data.AudioAssetId = data.AudioAssetId or "rbxassetid://0"
		data.AudioFilename = data.AudioFilename or "Unknown"
		data.AudioArtist = data.AudioArtist or "Unknown"

		return data
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
			return "rbxassetid://6799053340"
		end
	end

	function self:get_title_for_key(key)
		local songdata = self:get_data_for_key(key)
		return songdata.AudioFilename or "Unknown"
	end

	function self:get_artist_for_key(key)
		local songdata = self:get_data_for_key(key)
		return songdata.AudioArtist or "Unknown"
	end

	function self:get_md5_hash_for_key(key)
		local songdata = self:get_data_for_key(key)
		return songdata.AudioMD5Hash
	end

	function self:get_difficulty_for_key(key, rate)
		rate = if rate then rate else 1

		local songdata = self:get_data_for_key(key)

		local difficulty = songdata.AudioDifficulty

		if typeof(difficulty) == "number" then
			return {
				Overall = difficulty
			}
		end

		-- if rate == 1 then
		-- 	return difficulty
		-- elseif rate < 1 then
		-- 	return difficulty * (459616.4 + (-0.008317092 - 459616.4)/(1 + (rate/5051.127)^1.532436))
		-- else
		-- 	return difficulty * (946.4179 + (-6.728875 - 946.4179)/(1 + (rate/85114960)^0.2634697))
		-- end

		local index = (rate * 1000 - 600) / 100

		if tostring(index):find("%.") then
			local top = difficulty[math.ceil(index)]
			local bottom = difficulty[math.floor(index)]

			local ret = {}

			-- average all properties except for Rate

			for itr_key, itr_value in pairs(top) do
				if itr_key ~= "Rate" then
					ret[itr_key] = (itr_value + bottom[itr_key]) / 2
				else
					ret[itr_key] = itr_value
				end
			end

			return ret
		end

		return difficulty[index]
	end

	function self:get_description_for_key(key)
		local songdata = self:get_data_for_key(key)
		return songdata.AudioDescription
	end

	function self:get_mapper_for_key(key)
		local songdata = self:get_data_for_key(key)
		
		if songdata.AudioMapper ~= nil then
			return songdata.AudioMapper
		else
			return "Unknown"
		end
	end

	function self:get_song_length_for_key(key, rate)
		local hit_objects = self:get_hit_objects_for_key(key)
		local last_hit_ob = hit_objects[#hit_objects]

		if rate then
			return (last_hit_ob.Time + (last_hit_ob.Duration or 0)) / rate
		end
		
		return last_hit_ob.Time + (last_hit_ob.Duration or 0)
	end

	function self:get_skillsets_for_key(key, rate)
		local difficulty = self:get_difficulty_for_key(key, rate)

		local topSkillsets = {}
		local allSkillsets = {}

		for skillset, skillsetDiff in pairs(difficulty) do
			if skillset == "Rate" or skillset == "Overall" then
				continue
			end

			table.insert(allSkillsets, string.format("%s: %d", skillset, self:get_glicko_estimate_from_rating(skillsetDiff)))

			if math.abs(difficulty.Overall - skillsetDiff) < 3 and #topSkillsets < 4 then
				table.insert(topSkillsets, skillset)
			end
		end

		return topSkillsets, allSkillsets
	end
	
	function self:get_nps_graph_for_key(key, resolution)
		resolution = resolution or 1

		local hitobjects = self:get_hit_objects_for_key(key)

		local lastTime = 0
		local nps = 0

		local graph = {}

		for itr_index, itr_hit_object in ipairs(hitobjects) do
			if itr_hit_object.Time - lastTime > 1000 then
				if itr_index % resolution == 0 then
					table.insert(graph, nps)
				end
				lastTime = itr_hit_object.Time
				nps = 0
				continue
			end
			nps += 1
		end

		return graph
	end

	function self:get_search_string_for_key(key, rate)
		local data = self:get_data_for_key(key)
		local difficulty = self:get_difficulty_for_key(key, rate)

		if data ~= nil then
			local topSkillsets = self:get_skillsets_for_key(key, rate)

			local _search_data = {
				data.AudioArtist or "Unknown",
				data.AudioFilename or "Unknown",
				"diff=" .. string.format("%0.2f", difficulty.Overall),
				data.AudioMapper or "unknown",
			}

			for _, skillset in topSkillsets do
				table.insert(_search_data, skillset)
			end

			return table.concat(_search_data, " "):lower()
		end

		return ""
	end

	function self:filter_keys(str, rate, excludeCustomMaps)
		local ret = {}

		for key, data in self:key_itr() do
			if excludeCustomMaps and data.AudioCustom then
				continue
			end

			if not str or str == "" then
				table.insert(ret, data)
			else
				local terms = string.split(str, " ")
				local search_str = self:get_search_string_for_key(key, rate)

				local foundCount = 0

				for _, term in terms do
					if string.find(search_str:lower(), term:lower()) ~= nil then
						foundCount += 1
					end
				end

				if foundCount == #terms then
					table.insert(ret, data)
				end
			end
		end

		return ret
	end

	function self:get_hit_objects_for_key(key, rate, mirror)
		local data = self:get_data_for_key(key)
		local map_data = _map_data_cache:get(key)

		if not map_data then
			local splits = data.AudioMapData:GetChildren()

			-- Map data is split up into 200k character blocks due to Roblox's limit of 200k characters per StringValue instance.
			-- We use StringValues instead of ModuleScripts because using ModuleScripts causes massive performace problems in Studio.

			table.sort(splits, function(a, b)
				return tonumber(a.Name) < tonumber(b.Name)
			end)

			local map_json = ""

			for _, split in ipairs(splits) do
				map_json ..= split.Value
			end

			map_data = HttpService:JSONDecode(map_json)

			_map_data_cache:add(key, map_data)
		end

		if (rate == 1 or rate == nil) and (not mirror) then
			return map_data
		else
			local _rate_map_data = {}

			for i = 1, #map_data do
				local itr_hit_object = map_data[i]

				if itr_hit_object.Type == 1 then
					_rate_map_data[i] = {
						Time = itr_hit_object.Time / rate,
						Track = mirror and 5 - itr_hit_object.Track or itr_hit_object.Track,
						Type = itr_hit_object.Type
					}
				elseif itr_hit_object.Type == 2 then
					_rate_map_data[i] = {
						Time = itr_hit_object.Time / rate,
						Track = mirror and 5 - itr_hit_object.Track or itr_hit_object.Track,
						Duration = itr_hit_object.Duration / rate,
						Type = itr_hit_object.Type
					}
				end
			end

			return _rate_map_data
		end
	end

	function self:get_key_for_hash(hash)
		for itr_key, itr_audio_data in pairs(_all_keys) do
			if itr_audio_data.AudioMD5Hash == hash then
				return itr_key
			end
		end
		return self:invalid_songkey()
	end

	function self:get_hash_for_key(key)
		local songdata = self:get_data_for_key(key)
		return songdata.AudioMD5Hash
	end

	function self:get_note_metrics_for_key(key)
		local total_notes = 0
		local total_holds = 0
		local total_left_hand_objects = 0
		local total_right_hand_objects = 0

		for _, hit_object in pairs(self:get_hit_objects_for_key(key)) do
			if hit_object.Type == 1 then
				total_notes += 1
			elseif hit_object.Type == 2 then
				total_holds += 1
			end

			if hit_object.Track > 2 then
				total_right_hand_objects += 1
			else
				total_left_hand_objects += 1
			end
		end

		return total_notes, total_holds, total_left_hand_objects, total_right_hand_objects
	end
	
	function self:invalid_songkey() return -1 end

	self:cons()

	return self
end

return SongDatabase:new()