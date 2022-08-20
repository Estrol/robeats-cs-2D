local Knit = require(game.ReplicatedStorage.Packages.Knit)
local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRouter = require(game.ReplicatedStorage.Packages.RoactRouter)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local Actions = require(game.ReplicatedStorage.Actions)

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
local Moderation = require(Screens.Moderation)
local Multiplayer = require(Screens.Multiplayer)
local Room = require(Screens.Room)

local TopBar = require(game.ReplicatedStorage.UI.Components.TopBar)

local RoactController = Knit.CreateController({
    Name = "RoactController"
})

function RoactController:KnitStart()
    local store = Knit.GetController("StateController").Store
    self:MountRoactNodes(store)
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
            alwaysRender = true,
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
        Moderation = Roact.createElement(RoactRouter.Route, {
            path = "/moderation/:path",
            exact = true,
            component = Moderation
        }),
        Multiplayer = Roact.createElement(RoactRouter.Route, {
            path = "/multiplayer",
            exact = true,
            component = Multiplayer
        }),
        Room = Roact.createElement(RoactRouter.Route, {
            path = "/room",
            exact = true,
            component = Room
        })
    }
end

function RoactController:GetDependencies()
    return {
        ScoreService = Knit.GetService("ScoreService"),
        ModerationService = Knit.GetService("ModerationService"),
        PreviewController = Knit.GetController("PreviewController"),
        MultiplayerService = Knit.GetService("MultiplayerService"),
        FriendsController = Knit.GetController("FriendsController"),
        ChatService = Knit.GetService("ChatService"),
        SettingsService = Knit.GetService("SettingsService"),
        SFXController = Knit.GetController("SFXController"),
        FadeController = Knit.GetController("FadeController"),
        SpectatingService = Knit.GetService("SpectatingService"),
    }
end

function RoactController:MountRoactNodes(store)
    local routes = self:GetRoutes()

    local history = RoactRouter.History.new({ "/" }, 1)

    local fadeController = Knit.GetController("FadeController")

    local oldPush = history.push
    local oldGoBack = history.goBack

    local lastBasePath = string.match(history.location.path, "^(/[^/]+)")
    local lastPath = history.location.path

    local isTransitioning = false

    function history:push(...)
        if isTransitioning then
            return
        end

        local args = { ... }

        isTransitioning = true

        local newBasePath = string.match(args[1], "^(/[^/]+)")

        if newBasePath == lastBasePath then
            oldPush(self, unpack(args))
            isTransitioning = false
            return
        end

        lastBasePath = newBasePath

        return fadeController:To("In"):andThen(function()
            oldPush(self, unpack(args))
            isTransitioning = false
        end):andThen(function()
            fadeController:To("Out")
        end)
    end

    function history:goBack()
        if isTransitioning then
            return
        end

        local lastItem = history._entries[#history._entries - 1]

        isTransitioning = true

        local newBasePath = string.match(lastItem.path, "^(/[^/]+)")

        if newBasePath == lastBasePath then
            oldGoBack(self)
            isTransitioning = false
            return
        end

        lastBasePath = newBasePath
        
        return fadeController:To("In"):andThen(function()
            oldGoBack(self)
            isTransitioning = false
        end):andThen(function()
            fadeController:To("Out")
        end)
    end

    local router = Roact.createElement(RoactRouter.Router, {
        history = history
    }, routes)

    local storeProvider = Roact.createElement(RoactRodux.StoreProvider, {
        store = store
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
