local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local StateController = Knit.CreateController { Name = "StateController" }

local Actions = require(game.ReplicatedStorage.Actions)
local State = require(game.ReplicatedStorage.State)

local PermissionsService

function StateController:KnitStart()
    PermissionsService = Knit.GetService("PermissionsService")

    local _, hasAdmin = PermissionsService:HasModPermissions():await()

    State.Store:dispatch(Actions.setAdmin(hasAdmin))
end

return StateController
