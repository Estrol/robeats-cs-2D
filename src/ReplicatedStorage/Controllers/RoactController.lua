local Knit = require(game.ReplicatedStorage.Knit)
local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRouter = require(game.ReplicatedStorage.Packages.RoactRouter)

local EnvironmentSetup = require(game.ReplicatedStorage.RobeatsGameCore.EnvironmentSetup)

local TestComponent = require(game.ReplicatedStorage.UI.Components.TestComponent)

local RoactController = Knit.CreateController({
    Name = "RoactController"
})

function RoactController:KnitStart()
    self:MountRoactNodes()
end

function RoactController:MountRoactNodes()
    local routes = {
        Main = Roact.createElement(RoactRouter.Route, {
            path = "/",
            component = TestComponent
        })
    }

    local router = Roact.createElement(TestComponent, {
        initialEntries = { "/" },
        initialIndex = 1
    }, routes)

    -- Mount the router to the ScreenGui in PlayerGui
    Roact.mount(router, EnvironmentSetup:get_player_gui_root())
end

return RoactController
