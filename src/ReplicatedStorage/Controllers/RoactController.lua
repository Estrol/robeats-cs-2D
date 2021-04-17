local Knit = require(game.ReplicatedStorage.Knit)
local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRouter = require(game.ReplicatedStorage.Packages.RoactRouter)

local EnvironmentSetup = require(game.ReplicatedStorage.RobeatsGameCore.EnvironmentSetup)

local Screens = game.ReplicatedStorage.UI.Screens

local SongSelect = require(Screens.SongSelect)

local RoactController = Knit.CreateController({
    Name = "RoactController"
})

function RoactController:KnitStart()
    self:MountRoactNodes()
end

function RoactController:GetRoutes()
    return {
        Main = Roact.createElement(RoactRouter.Route, {
            path = "/",
            component = SongSelect
        })
    }
end

function RoactController:MountRoactNodes()
    local routes = self:GetRoutes()

    local router = Roact.createElement(RoactRouter.Router, {
        initialEntries = { "/" },
        initialIndex = 1
    }, routes)

    -- Mount the router to the ScreenGui in PlayerGui
    Roact.mount(router, EnvironmentSetup:get_player_gui_root())
end

return RoactController
