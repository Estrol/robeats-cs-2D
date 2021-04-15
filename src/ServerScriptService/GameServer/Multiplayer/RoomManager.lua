local HttpService = game:GetService("HttpService")

local Remotes = require(game.ReplicatedStorage.Remotes)
local RoomRemotes = require(game.ServerScriptService.GameServer.Multiplayer.RoomRemotes)

local Room = require(game.ServerScriptService.GameServer.Multiplayer.Room)

local RoomManager = {}

local _rooms = {}

function RoomManager:cons()

end

function RoomManager.add_room(player, name)
    name = name or string.format("%s's room", player.Name)

    local _room = Room:new()
    _room:set_host(player)
    _room:set_name(name)
    _room:add_player(player)

    _rooms[_room.id] = _room

    RoomRemotes.OnRoomAdded:SendToAllPlayers(_room:get_metadata())

    return _room:get_metadata()
end

function RoomManager.join_room(player, id)
    local room = _rooms[id]

    if room then
        return room:add_player(player)
    end
    
    return nil
end

function RoomManager.leave_room(player, id)
    local room = _rooms[id]

    if room then
        local remove_room = room:remove_player(player)

        if remove_room then
            RoomManager.remove_room(player, id)
        end
    end
    
    return nil
end

function RoomManager.remove_room(player, id)
    local room = _rooms[id]
    
    if room == nil then
        return
    end

    local _metadata

    if room.host.UserId == player.UserId or room.players:count() == 0 then
        _metadata = room:get_metadata()
        RoomRemotes.OnRoomRemoved:SendToAllPlayers(_metadata)
        _rooms[id] = nil
    end

    return _metadata
end


function RoomManager.get_room(_, id)
    if _rooms[id] == nil then
        return nil
    end
    return _rooms[id]:get_metadata()
end

function RoomManager.get_rooms()
    local out = {}

    for i, v in pairs(_rooms) do
        out[i] = v:get_metadata()
    end

    return out
end

RoomManager:cons()

return RoomManager
