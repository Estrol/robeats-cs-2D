local Knit = require(game:GetService("ReplicatedStorage").Knit)

local StateController = Knit.CreateController { Name = "StateController" }

local Rodux = require(game.ReplicatedStorage.Packages.Rodux)

local OptionsReducer = require(game.ReplicatedStorage.Reducers.OptionsReducer)
local PermissionsReducer = require(game.ReplicatedStorage.Reducers.PermissionsReducer)

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local Actions = require(game.ReplicatedStorage.Actions)

local PermissionsService

function StateController:KnitInit()
    PermissionsService = Knit.GetService("PermissionsService")

    local combinedReducers = Rodux.combineReducers({
        options = OptionsReducer,
        permissions = PermissionsReducer
    })
        
    self.Store = Rodux.Store.new(combinedReducers)

    self.Store:dispatch(Actions.setAdmin(PermissionsService:HasModPermissions()))
    self.Store:dispatch(Actions.setTransientOption("SongKey", math.random(1, SongDatabase:get_key_count())))
end

return StateController
