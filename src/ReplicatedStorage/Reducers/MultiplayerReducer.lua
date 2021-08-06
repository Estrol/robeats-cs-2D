local HttpService = game:GetService("HttpService")

local Rodux = require(game.ReplicatedStorage.Packages.Rodux)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local createReducer = Rodux.createReducer

local join = Llama.Dictionary.join
local set = Llama.Dictionary.set

local function createRoom(player, name, image, password)
    return {
        name = name or string.format("%s's room", player.Name),
        image = image or "rbxassetid://6800827231",
        players = { player }, -- Add the player that created the room to the list of players
        password = password,
        host = player,
        selectedSongKey = 1
    }
end

local defaultState = {
    rooms = {}
}

return createReducer(defaultState, {
    createRoom = function(state, action)
        local id = HttpService:GenerateGUID(false)

        local room = createRoom(action.player, action.name, action.password)

        return join(state, {
            rooms = set(state.rooms, id, room)
        })
    end,
    setHost = function(state, action)
        return join(state, {
            rooms = join(state.rooms, {
                [action.id] = join(state.rooms[action.id], {
                    host = action.host
                })
            })
        })
    end
})
