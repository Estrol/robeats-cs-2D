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

return MultiplayerService
