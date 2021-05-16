local Rodux = require(game.ReplicatedStorage.Packages.Rodux)

local Reducers = game.ReplicatedStorage.Reducers

local OptionsReducer = require(Reducers.OptionsReducer)
local PermissionsReducer = require(Reducers.PermissionsReducer)

local combinedReducers = Rodux.combineReducers({
    options = OptionsReducer,
    permissions = PermissionsReducer
})

local Store = Rodux.Store.new(combinedReducers)

return {
    Store = Store
}
