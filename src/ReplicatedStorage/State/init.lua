local Rodux = require(game.ReplicatedStorage.Packages.Rodux)

local Reducers = game.ReplicatedStorage.Reducers

local OptionsReducer = require(Reducers.OptionsReducer)
local PermissionsReducer = require(Reducers.PermissionsReducer)

local isServer = game:GetService("RunService"):IsServer()

if isServer then        
    return function()
        return Rodux.Store.new()
    end
else
    return function()
        local combinedReducers = Rodux.combineReducers({
            options = OptionsReducer,
            permissions = PermissionsReducer
        })
        
        return Rodux.Store.new(combinedReducers)
    end
end
