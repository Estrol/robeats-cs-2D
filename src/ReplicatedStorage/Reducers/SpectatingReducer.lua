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

local defaultState = {
    players = {}
}

return createReducer(defaultState, {
    addPlayerToSpectate = function(state, action)
        return join(state, {
            players = push(state.players, {
                player = action.player,
                songHash = action.songHash,
                songRate = action.songRate,
            })
        })
    end,
    removePlayerFromSpectate = function(state, action)
        return join(state, {
            players = removeIndex(state.players, findWhere(state.players, function(player)
                return player.player == action.player
            end))
        })
    end,
})
