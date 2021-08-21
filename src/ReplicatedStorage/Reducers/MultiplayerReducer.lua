local Rodux = require(game.ReplicatedStorage.Packages.Rodux)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local createReducer = Rodux.createReducer

local join = Llama.Dictionary.join
local copyDeep = Llama.Dictionary.copyDeep
local set = Llama.Dictionary.set
local removeKey = Llama.Dictionary.removeKey
local map = Llama.Dictionary.map

local push = Llama.List.push
local findWhere = Llama.List.findWhere
local removeValue = Llama.List.removeValue
local removeIndex = Llama.List.removeIndex

local function createMatch(room)
    return {
        players = map(room.players, function(player)
            return {
                player = player,
                score = 0,
                accuracy = 0,
                rating = 0,
                marvelouses = 0,
                perfects = 0,
                greats = 0,
                goods = 0,
                bads = 0,
                misses = 0,
                mean = 0,
                ready = false
            }
        end),
        selectedSongKey = room.selectedSongKey,
        ongoing = true,
        songRate = room.songRate
    }
end

local function createRoom(player, name, image, password)
    return {
        name = player and (name or string.format("%s's room", player.Name)),
        image = image or "rbxassetid://6800827231",
        players = { player }, -- Add the player that created the room to the list of players
        password = password,
        host = player,
        selectedSongKey = 1,
        inProgress = false,
        songRate = 100
    }
end

local defaultState = {
    rooms = {},
    matches = {}
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
        local playerIndex = findWhere(state.matches[action.roomId].players, function(player)
            return player.player.UserId == action.player.UserId
        end)

        local roomPlayers = removeValue(state.rooms[action.roomId].players, action.player)
        local matchPlayers = removeIndex(state.matches[action.roomId].players, playerIndex)

        return join(state, {
            matches = join(state.matches, {
                [action.roomId] = join(state.matches[action.roomId], {
                    players = matchPlayers
                })
            }),
            rooms = join(state.rooms, {
                [action.roomId] = join(state.rooms[action.roomId], {
                    players = roomPlayers
                })
            })
        })
    end,
    removeRoom = function(state, action)
        return join(state, {
            rooms = join(state.rooms, {
                [action.roomId] = Llama.None
            }),
            matches = join(state.matches, {
                [action.roomId] = Llama.None
            })
        })
    end,
    startMatch = function(state, action)
        local match = createMatch(state.rooms[action.roomId])

        return join(state, {
            matches = set(state.matches, action.roomId, match),
            rooms = join(state.rooms, {
                [action.roomId] = join(state.rooms[action.roomId], {
                    inProgress = true
                })
            })
        })
    end,
    abortMatch = function(state, action)
        return join(state, {
            matches = removeKey(state.matches, action.roomId),
            rooms = join(state.rooms, {
                [action.roomId] = join(state.rooms[action.roomId], {
                    inProgress = false
                })
            })
        }) 
    end,
    endMatch = function(state, action)
        return join(state, {
            matches = join(state.matches, {
                [action.roomId] = set(state.matches[action.roomId], "ongoing", false)
            }),
            rooms = join(state.rooms, {
                [action.roomId] = join(state.rooms[action.roomId], {
                    inProgress = false
                })
            })
        })
    end,
    setReady = function(state, action)
        local mutableState = copyDeep(state)
        local playerIndex = findWhere(state.matches[action.roomId].players, function(player)
            return player.player.UserId == action.userId
        end)

        local match = mutableState.matches[action.roomId]
        match.players[playerIndex].ready = action.value

        local room = mutableState.rooms[action.roomId]

        if #Llama.Dictionary.filter(match.players, function(player)
            return not player.ready
        end) == 0 then
            room.inProgress = false
        end

        return mutableState
    end,
    setMatchStats = function(state, action)
        local mutableState = copyDeep(state)
        local playerIndex = findWhere(state.matches[action.roomId].players, function(player)
            return player.player.UserId == action.userId
        end)

        mutableState.matches[action.roomId].players[playerIndex] = join(mutableState.matches[action.roomId].players[playerIndex], {
            score = action.score,
            accuracy = action.accuracy,
            rating = action.rating,
            marvelouses = action.marvelouses,
            perfects = action.perfects,
            greats = action.greats,
            goods = action.goods,
            bads = action.bads,
            misses = action.misses,
            mean = action.mean,
            maxCombo = action.maxCombo
        })

        return mutableState
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
    setSongKey = function(state, action)
        return join(state, {
            rooms = join(state.rooms, {
                [action.roomId] = join(state.rooms[action.roomId], {
                    selectedSongKey = action.songKey
                })
            })
        })
    end,
    setSongRate = function(state, action)
        return join(state, {
            rooms = join(state.rooms, {
                [action.roomId] = join(state.rooms[action.roomId], {
                    songRate = action.songRate
                })
            })
        })
    end,
    setState = function(_, action)
        return action.state.multiplayer
    end
})
