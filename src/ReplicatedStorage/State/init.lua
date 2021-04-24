local Rodux = require(game.ReplicatedStorage.Packages.Rodux)

local Reducers = game.ReplicatedStorage.Reducers

local OptionsReducer = require(Reducers.OptionsReducer)

local combinedReducers = Rodux.combineReducers({
    options = OptionsReducer
})

local Store = Rodux.Store.new(combinedReducers)

return {
    Store = Store
}
