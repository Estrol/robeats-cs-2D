local AssertType = require(game.ReplicatedStorage.Shared.AssertType)

local GameRooms = workspace:WaitForChild("GameRooms")
local TextService = game:GetService("TextService")
local Constructors = game.ServerScriptService.Constructors

local MultiplayerAPI = {}

local constructRoom = require(Constructors.constructRoom)
local constructPlayer = require(Constructors.constructPlayer)

local passwords = {}

function getTextObject(message, fromPlayerId)
	local textObject
	local success, errorMessage = pcall(function()
		textObject = TextService:FilterStringAsync(message, fromPlayerId)
	end)
	if success then
		return textObject
	elseif errorMessage then
		print("Error generating TextFilterResult:", errorMessage)
	end
	return false
end

function getFilteredMessage(textObject)
	local filteredMessage
	local success, errorMessage = pcall(function()
		filteredMessage = textObject:GetNonChatStringForBroadcastAsync()
	end)
	if success then
		return filteredMessage
	elseif errorMessage then
		print("Error filtering message:", errorMessage)
	end
	return false
end

function MultiplayerAPI.UpdateMAValues(player, _current_room, values)
    AssertType:is_classname(_current_room, "StringValue")
    AssertType:is_non_nil(values)

    if _current_room then
        local player_ob
        for _, itr_player in pairs(_current_room.Players:GetChildren()) do
            if itr_player.Value.UserId == player.UserId then
                player_ob = itr_player
                break
            end
        end

        if player_ob then
            player_ob.Marvelouses.Value = values.marvelouses
            player_ob.Perfects.Value = values.perfects
            player_ob.Greats.Value = values.greats
            player_ob.Goods.Value = values.goods
            player_ob.Bads.Value = values.bads
            player_ob.Misses.Value = values.misses
            player_ob.Accuracy.Value = values.accuracy
            player_ob.Score.Value = values.score
            player_ob.CurCombo.Value = values.chain
            player_ob.MaxCombo.Value = values.max_chain
            return true
        end
    end

    return false
end

function MultiplayerAPI.JoinRoom(player, _current_room, password)
    AssertType:is_classname(_current_room, "StringValue")

	local tar_password = passwords[_current_room]

	if password == tar_password or tar_password == nil or tar_password == "" then
		local player_ob = constructPlayer(player)
        player_ob.Parent = _current_room.Players
        return true
    end
    
    return false
end

-- function ShutdownRoom(player, _current_room)
-- 	if player:GetRankInGroup(5863946) >= 251 then
-- 		if _current_room then
-- 			for i,v in pairs(_current_room.Players:GetChildren()) do
-- 				_current_room.Players[v.Name]:Destroy()
-- 			end
-- 			DeleteRoom(player, _current_room)
-- 		end
-- 	end
-- 	return true
-- end

function MultiplayerAPI.SetMap(player, _current_room, song_index)
    AssertType:is_classname(_current_room, "StringValue")
    AssertType:is_number(song_index)

	if _current_room then
		local host = _current_room.Players.Value
		if player == host then
			_current_room.SelectedSongIndex.Value = song_index
		end
		return true
	end
	return false
end

function MultiplayerAPI.SetPlayRate(player, _current_room, song_rate)
    AssertType:is_classname(_current_room, "StringValue")
    AssertType:is_number(song_rate)

	if _current_room then
		local host = _current_room.Players.Value
		if player == host then
			_current_room.SelectedSongRate.Value = song_rate
		end
	end
	return true
end

function MultiplayerAPI.DeleteRoom(_, _current_room)	
	if _current_room then
		_current_room:Destroy()
	end
	return true
end

function MultiplayerAPI.TransferHost(player, _current_room, target_player)
    AssertType:is_classname(_current_room, "StringValue")
    AssertType:is_classname(target_player, "Player")

	if _current_room then
		local host = _current_room.Players
		if player == host.Value then
			host.Value = target_player
		end
	end
	return true
end

function MultiplayerAPI.ChangeName(player, _current_room, new_name)
    AssertType:is_classname(_current_room, "StringValue")
    AssertType:is_string(new_name)

	if _current_room then
		local host = _current_room.Players.Value
		if player == host then
			local textobject = getTextObject(new_name, player.UserId)
			local filtered_name = ""
			filtered_name = getFilteredMessage(textobject)
			_current_room.Value = filtered_name
		end
	end
	return true
end

function MultiplayerAPI.ChangePassword(player, _current_room, password)
    AssertType:is_classname(_current_room, "StringValue")
    AssertType:is_string(password)

	if _current_room then
		local host = _current_room.Players.Value
		if player == host then
			passwords[_current_room] = password
		end
	end
	return true
end

function MultiplayerAPI.KickPlayer(player, _current_room, _player_to_kick)
    AssertType:is_classname(_current_room, "StringValue")

	if _current_room then
		local host = _current_room.Players.Value
		if player == host then
			if _player_to_kick ~= player then
				_current_room.Players[_player_to_kick.Name]:Destroy()
			end
		end
		if #_current_room.Players:GetChildren() == 0 then
			MultiplayerAPI.DeleteRoom(player, _current_room)
		end
	end
	return true
end

function MultiplayerAPI.LeaveRoom(player, _current_room)
    AssertType:is_classname(_current_room, "StringValue")

	if _current_room then
		local ob = _current_room.Players:FindFirstChild(player.Name)
		local host = _current_room.Players.Value
		if ob then
			ob:Destroy()
		end
		if #_current_room.Players:GetChildren() == 0 then
			MultiplayerAPI.DeleteRoom(player, _current_room)
		elseif #_current_room.Players:GetChildren() > 0 and player == host then
			_current_room.Players.Value = _current_room.Players:GetChildren()[math.random(1, #_current_room.Players:GetChildren())]
		end
		return true
	end
	return false
end

function MultiplayerAPI.Ready(player, _current_room)
    AssertType:is_classname(_current_room, "StringValue")

	if _current_room then
		local ob = _current_room.Players:FindFirstChild(player.Name)
		local host = _current_room.Players.Value
		if player == host then
			_current_room.SongStarted.Value = false
		end
		if ob then
			ob.IsReady.Value = true
		end
		return true
	end
	return false
end

function MultiplayerAPI.Abort(player, _current_room)
	AssertType:is_classname(_current_room, "StringValue")

	local host = _current_room.Players.Value
	if player == host then
		_current_room.Aborted.Value = false
		MultiplayerAPI.Finished(player, _current_room)
	end
end

function MultiplayerAPI.Finished(player, _current_room)
    AssertType:is_classname(_current_room, "StringValue")

	if _current_room then
		for _, itr_player in ipairs(_current_room.Players:GetChildren()) do
			if itr_player.Value.UserId == player.UserId then
				itr_player.IsReady = false
				break
			end
		end
	end
end

function MultiplayerAPI.PlayMap(player, _current_room)
    AssertType:is_classname(_current_room, "StringValue")

	if _current_room then
		local host = _current_room.Players.Value
		if player == host then
			for _, itr_player in pairs(_current_room.Players:GetChildren()) do
				itr_player.IsReady.Value = false
			end
			_current_room.SongStarted.Value = true
			_current_room.InGame.Value = true
		end
		return true
	end
	return false
end

function MultiplayerAPI.BuildMPRoom(player, _selected_map, _play_rate, password)
    AssertType:is_number(_selected_map)
    AssertType:is_number(_play_rate)

    local _current_room = constructRoom(player, _selected_map, _play_rate)
    _current_room.Parent = GameRooms
	
    if password then
        passwords[_current_room] = password
    end

	MultiplayerAPI.JoinRoom(player, _current_room, password)

	return _current_room
end

game.Players.PlayerRemoving:Connect(function(player)
	for _, room in pairs(GameRooms:GetChildren()) do
		for _, room_player in pairs(room.Players:GetChildren()) do
			if player == room_player.Value then
				room_player:Destroy()
				if #room.Players:GetChildren() > 0 then
					local host = room.Players
					if player == host.Value then
						room.Players.Value = host:GetChildren()[math.random(1, #host:GetChildren())]
					end
				end
			end
		end
		if #room.Players:GetChildren() == 0 then
			MultiplayerAPI.DeleteRoom(player, room)
		end
	end
end)

-- game.Players.PlayerAdded:Connect(function(p)
-- 	local score_data = Instance.new("IntValue",p)
-- 	score_data.Name = "Okays"
-- 	score_data = Instance.new("NumberValue",p)
-- 	score_data.Name = "Goods"
-- 	score_data = Instance.new("NumberValue",p)
-- 	score_data.Name = "Greats"
-- 	score_data = Instance.new("NumberValue",p)
-- 	score_data.Name = "Perfects"
-- 	score_data = Instance.new("NumberValue",p)
-- 	score_data.Name = "Marvelouses"
-- 	score_data = Instance.new("NumberValue",p)
-- 	score_data.Name = "Misses"
-- 	score_data = Instance.new("NumberValue",p)
-- 	score_data.Name = "judgeCount"
-- 	score_data = Instance.new("NumberValue",p)
-- 	score_data.Name = "Accuracy"
-- 	score_data = Instance.new("NumberValue",p)
-- 	score_data.Name = "Score"
-- 	score_data = Instance.new("NumberValue",p)
-- 	score_data.Name = "CurCombo"
-- 	score_data = Instance.new("NumberValue",p)
-- 	score_data.Name = "MaxCombo"
-- 	score_data = Instance.new("NumberValue",p)
-- 	score_data.Name = "Grade"
-- 	score_data = Instance.new("NumberValue",p)
-- 	score_data.Name = "PlayRating"
-- 	score_data = Instance.new("NumberValue",p)
-- 	score_data.Name = "UnstableRate"
-- 	score_data = Instance.new("NumberValue",p)
-- 	score_data.Name = "AverageOffset"
-- 	score_data = Instance.new("StringValue",p)
-- 	score_data.Name = "NoteDeviance"
-- end)

function MultiplayerAPI.SubmitNoteDeviance(player, _current_room, _data)
    AssertType:is_classname(_current_room, "StringValue")
    AssertType:is_non_nil(_data)

    -- TODO: add more here lol xdfsfdghklbjn gfdslnjkhksdgrfljkhnbnagdefsl.j,edrffglk,jhygbaesrfgk, jmhnmdsg
end

return MultiplayerAPI