local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local HttpService = game:GetService("HttpService")

local MultiplayerService = Knit.CreateService {
    Name = "MultiplayerService";
    Client = {};
}

local Llama

local StateService

local AssertType

local Passwords = {}

function MultiplayerService:KnitStart()
    game.Players.PlayerRemoving:Connect(function(player)
        local store = StateService.Store
        local state = MultiplayerService:GetState()

        for id, room in pairs(state.multiplayer.rooms) do
            for _, roomPlayer in pairs(room.players) do
                if roomPlayer.player == player then
                    store:dispatch({
                        type = "removePlayer",
                        roomId = id,
                        player = player
                    })
                end
            end
        end
    end)
end

function MultiplayerService:KnitInit()
    StateService = Knit.GetService("StateService")
    Llama = require(game.ReplicatedStorage.Packages.Llama)
    AssertType = require(game.ReplicatedStorage.Shared.AssertType)
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

    if password ~= "" then
        Passwords[id] = password
    end

    StateService.Store:dispatch({
        type = "createRoom",
        name = name,
        id = id,
        player = player,
        locked = password ~= ""
    })

    return id
end

function MultiplayerService:RemoveRoom(id)
    StateService.Store:dispatch({
        type = "removeRoom",
        roomId = id
    })
end

function MultiplayerService.Client:LeaveRoom(player, id)
    AssertType:is_string(id)

    local store = StateService.Store
    local state = MultiplayerService:GetState()

    local room = state.multiplayer.rooms[id]

    if room.players[tostring(player.UserId)] then
        if Llama.Dictionary.count(room.players) == 1 then
            MultiplayerService:RemoveRoom(id)
            return
        end

        store:dispatch({
            type = "removePlayer",
            player = player,
            roomId = id
        })

        if MultiplayerService:IsHost(player, id) then
            print("Host left")

            local players = Llama.Dictionary.filter(room.players, function(compPlayer)
                return compPlayer.player ~= player
            end)

            players = Llama.Dictionary.values(players)

            print(players)

            local newHost = players[math.random(1, #players)]
            
            print("New host: " .. newHost.player.Name)
            
            store:dispatch({
                type = "setHost",
                roomId = id,
                host = newHost.player
            })
        end
    end
end

function MultiplayerService.Client:StartMatch(player, id)
    AssertType:is_string(id)

    local store = StateService.Store
    local state = MultiplayerService:GetState()

    if state.multiplayer.rooms[id] then
        if state.multiplayer.rooms[id].inProgress then
            return
        end
    else
        return
    end

    if MultiplayerService:IsHost(player, id) then
        store:dispatch({
            type = "startMatch",
            roomId = id
        })
    end
end

function MultiplayerService.Client:SetLoaded(player, id, value)
    AssertType:is_string(id)
    
    local store = StateService.Store

    store:dispatch({
        type = "setLoaded",
        roomId = id,
        userId = player.UserId,
        value = value
    })
end

function MultiplayerService.Client:TransferHost(player, id, newHostUserId)
    AssertType:is_number(newHostUserId)

    local newHost = game.Players:GetPlayerByUserId(newHostUserId)

    assert(newHost, "Host must exist in server")

    local store = StateService.Store
    local state = MultiplayerService:GetState()

    assert(state.multiplayer.rooms[id].host == player, "Non-host tried to set host")

    store:dispatch({
        type = "setHost",
        roomId = id,
        host = newHost
    })
end

function MultiplayerService.Client:SetFinished(player, id, value)
    AssertType:is_string(id)
    
    local store = StateService.Store

    store:dispatch({
        type = "setFinished",
        roomId = id,
        userId = player.UserId,
        value = value
    })
end

function MultiplayerService.Client:SetSongKey(player, id, key)
    AssertType:is_string(id)

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
    AssertType:is_string(id)

    local store = StateService.Store

    if MultiplayerService:IsHost(player, id) then
        store:dispatch({
            type = "setSongRate",
            songRate = rate,
            roomId = id
        })
    end
end

function MultiplayerService.Client:JoinRoom(player, id, password)
    AssertType:is_string(id)

    local store = StateService.Store
    local state = MultiplayerService:GetState()

    if state.multiplayer.rooms[id].inProgress then
        return
    end

    if Passwords[id] then
        if Passwords[id] ~= password then
            return false
        end
    end

    store:dispatch({
        type = "addPlayer",
        player = player,
        roomId = id
    })

    return true
end

function MultiplayerService.Client:SetMatchStats(player, id, stats)
    AssertType:is_string(id)

    local store = StateService.Store

    local action = {
        type = "setMatchStats",
        roomId = id,
        userId = player.UserId
    }

    store:dispatch(Llama.Dictionary.join(action, stats))
end

return MultiplayerService
