local Knit = require(game.ReplicatedStorage.Knit)
local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRouter = require(game.ReplicatedStorage.Packages.RoactRouter)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)

local State = require(game.ReplicatedStorage.State)

local EnvironmentSetup = require(game.ReplicatedStorage.RobeatsGameCore.EnvironmentSetup)

local DIContext = require(game.ReplicatedStorage.Contexts.DIContext)

local Screens = game.ReplicatedStorage.UI.Screens

local MainMenu = require(Screens.MainMenu)
local SongSelect = require(Screens.SongSelect)
local Gameplay = require(Screens.Gameplay)
local Results = require(Screens.Results)
local Options = require(Screens.Options)
local Rankings = require(Screens.Rankings)
local Scores  = require(Screens.Scores)

local TopBar = require(game.ReplicatedStorage.UI.Components.TopBar)

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
            exact = true,
            component = MainMenu
        }),
        Select = Roact.createElement(RoactRouter.Route, {
            path = "/select",
            exact = true,
            component = SongSelect
        }),
        Gameplay = Roact.createElement(RoactRouter.Route, {
            path = "/play",
            exact = true,
            component = Gameplay
        }),
        Results = Roact.createElement(RoactRouter.Route, {
            path = "/results",
            exact = true,
            component = Results
        }),
        Options = Roact.createElement(RoactRouter.Route, {
            path = "/options",
            exact = true,
            component = Options
        }),
        Rankings = Roact.createElement(RoactRouter.Route, {
            path = "/rankings",
            exact = true,
            component = Rankings
        }),
        Scores = Roact.createElement(RoactRouter.Route, {
            path = "/scores",
            exact = true,
            component = Scores
        }),
        TopBar = Roact.createElement(RoactRouter.Route, {
            path = "/",
            exact = false,
            component = TopBar
        }),
    }
end

function RoactController:GetDependencies()
    return {
        ScoreService = Knit.GetService("ScoreService")
    }
end

function RoactController:MountRoactNodes()
    local routes = self:GetRoutes()

    local router = Roact.createElement(RoactRouter.Router, {
        initialEntries = { "/" },
        initialIndex = 1
    }, routes)

    local storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
        store = State.Store
    }, {
        AppRouter = router
    })

    local app = Roact.createElement(DIContext.Provider, {
        value = self:GetDependencies()
    }, {
        StoreProvider = storeProvider
    })

    -- Mount the router to the ScreenGui in PlayerGui
    Roact.mount(app, EnvironmentSetup:get_player_gui_root())
end

return RoactController
