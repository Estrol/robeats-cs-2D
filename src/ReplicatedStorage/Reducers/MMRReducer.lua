local Rodux = require(game.ReplicatedStorage.Packages.Rodux)
local Llama = require(game.ReplicatedStorage.Packages.Llama)

local defaultState = {}

return Rodux.createReducer(defaultState, {
    addMMR = function(state, action)        
        local mmrs = Llama.Dictionary.copy(state)

        mmrs[action.hash] = action.mmr

        return mmrs
    end
})
