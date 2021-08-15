local Rodux = require(game.ReplicatedStorage.Packages.Rodux)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local createReducer = Rodux.createReducer

local join = Llama.Dictionary.join
local set = Llama.Dictionary.set
local removeKey = Llama.Dictionary.removeKey

local push = Llama.List.push
local removeValue = Llama.List.removeValue

local function createRoom(player, name, image, password)
    return {
        name = player and (name or string.format("%s's room", player.Name)),
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
        local room = createRoom(action.player, action.name, action.password)

        return join(state, {
            rooms = set(state.rooms, action.id, room)
        })
    end,
    addPlayer = function(state, action)
        local players = push(state.rooms[action.roomId].players, action.player)

        return join(state, {
            rooms = join(state.rooms, {
                [action.roomId] = join(state.rooms[action.roomId], {
                    players = players
                })
            })
        })
    end,
    removePlayer = function(state, action)
        local players = removeValue(state.rooms[action.roomId].players, action.player)

        return join(state, {
            rooms = join(state.rooms, {
                [action.roomId] = join(state.rooms[action.roomId], {
                    players = players
                })
            })
        })
    end,
    removeRoom = function(state, action)
        return join(state, {
            rooms = join(state.rooms, {
                [action.roomId] = Llama.None
            })
        })
    end,
    setHost = function(state, action)
        return join(state, {
            rooms = join(state.rooms, {
                [action.roomId] = join(state.rooms[action.roomId], {
                    host = action.host
                })
            })
        })
    end,
    setState = function(_, action)
        return action.state.multiplayer
    end
})
