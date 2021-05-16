local Rodux = require(game.ReplicatedStorage.Packages.Rodux)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local createReducer = Rodux.createReducer

local join = Llama.Dictionary.join

local defaultState = {
    isAdmin = false
}

return createReducer(defaultState, {
    setAdmin = function(state, action)
        return join(state, {
            isAdmin = action.value
        })
    end
})
