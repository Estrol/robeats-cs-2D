local Knit = require(game:GetService("ReplicatedStorage").Knit)
local HttpService = game:GetService("HttpService")

local MultiplayerService = Knit.CreateService {
    Name = "MultiplayerService";
    Client = {};
}

local StateService

function MultiplayerService:KnitInit()
    StateService = Knit.GetService("StateService")
end

function MultiplayerService:GetState()
    return StateService.Store:getState()
end

function MultiplayerService:IsHost(player, id)
    local state = self:GetState()
    return state.multiplayer.rooms[id].host == player
end

function MultiplayerService.Client:AddRoom(player, name, password)
    local id = HttpService:GenerateGUID(false)

    StateService.Store:dispatch({
        type = "createRoom",
        name = name,
        id = id,
        player = player,
        password = password
    })

    return id
end

function MultiplayerService.Client:RemoveRoom(player)

end

function MultiplayerService.Client:LeaveRoom(player, id)
    local store = StateService.Store
    local state = store:getState()

    if table.find(state.multiplayer.rooms[id].players, player) then
        if #state.multiplayer.rooms[id].players == 1 then
            store:dispatch({
                type = "removeRoom",
                roomId = id
            })
            return
        end
        store:dispatch({
            type = "removePlayer",
            player = player,
            roomId = id
        })
    end
end

function MultiplayerService.Client:StartMatch(player, id)
    local store = StateService.Store
    local state = MultiplayerService:GetState()

    if state.multiplayer.matches[id] then
        return
    end

    if MultiplayerService:IsHost(player, id) then
        store:dispatch({
            type = "startMatch",
            roomId = id
        })
    end
end

function MultiplayerService.Client:SetReady(player, id, value)
    local store = StateService.Store

    store:dispatch({
        type = "setReady",
        roomId = id,
        userId = player.UserId,
        value = value
    })
end

function MultiplayerService.Client:SetSongKey(player, id, key)
    local store = StateService.Store

    if MultiplayerService:IsHost(player, id) then
        store:dispatch({
            type = "setSongKey",
            songKey = key,
            roomId = id
        })
    end
end

function MultiplayerService.Client:SetSongRate(player, id, rate)
    local store = StateService.Store

    if MultiplayerService:IsHost(player, id) then
        store:dispatch({
            type = "setSongRate",
            songRate = rate,
            roomId = id
        })
    end
end

function MultiplayerService.Client:JoinRoom(player, id)
    local store = StateService.Store

    store:dispatch({
        type = "addPlayer",
        player = player,
        roomId = id
    })
end

return MultiplayerService
