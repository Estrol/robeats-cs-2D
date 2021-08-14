local Knit = require(game:GetService("ReplicatedStorage").Knit)

local Actions = require(game.ReplicatedStorage.Actions)

local SettingsController = Knit.CreateController { Name = "SettingsController" }

function SettingsController:KnitStart()
    local store = Knit.GetController("StateController").Store
    local SettingsService = Knit.GetService("SettingsService")

    local settings = SettingsService:GetSettings()

    if settings then
        for i, v in pairs(settings) do
            store:dispatch(Actions.setPersistentOption(i, v))
        end 
    end
end

return SettingsController