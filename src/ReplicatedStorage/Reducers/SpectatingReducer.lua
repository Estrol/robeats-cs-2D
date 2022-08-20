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
    addPlayer = function(state, action)
        return join(state, {
            players = set(state.players, tostring(action.player.UserId), action.player)
        })
    end,
    removePlayer = function(state, action)
        return removeKey(state.players, tostring(action.player.UserId))
    end,
})
