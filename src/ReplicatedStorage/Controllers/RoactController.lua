local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Knit = require(game.ReplicatedStorage.Packages.Knit)
local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRouter = require(game.ReplicatedStorage.Packages.RoactRouter)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local Trove = require(game.ReplicatedStorage.Packages.Trove)

local UserInputService = game:GetService("UserInputService")

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
local Spectating = require(Screens.Spectating)
local Matchmaking = require(Screens.Matchmaking)
local RetryDelay = require(Screens.RetryDelay)

local TopBar = require(game.ReplicatedStorage.UI.Components.TopBar)

local RoactController = Knit.CreateController({
    Name = "RoactController"
})

function RoactController:KnitStart()
    local store = Knit.GetController("StateController").Store
    self:MountRoactNodes(store)

    self.store = store

    if UserInputService.TouchEnabled then
        self:ToggleCursor(false)
    end
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
        }),
        Spectating = Roact.createElement(RoactRouter.Route, {
            path = "/spectate",
            exact = true,
            component = Spectating
        }),
        Matchmaking = Roact.createElement(RoactRouter.Route, {
            path = "/matchmaking",
            exact = true,
            component = Matchmaking
        }),
        Retry = Roact.createElement(RoactRouter.Route, {
            path = "/retrydelay",
            exact = true,
            component = RetryDelay
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
        MatchmakingService = Knit.GetService("MatchmakingService")
    }
end

function RoactController:MountRoactNodes(store)
    local routes = self:GetRoutes()

    local history = RoactRouter.History.new({ "/" }, 1)

    local fadeController = Knit.GetController("FadeController")

    local oldPush = history.push
    local oldGoBack = history.goBack

    local lastBasePath = string.match(history.location.path, "^(/[^/]+)")

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


function RoactController:InitializeCursor()
    local state = self.store:getState()
    local cursorImageColor = state.options.persistent.CursorImageColor
    local hue, saturation, value = state.options.persistent.CursorImageColor:ToHSV()

    value *= .85

    local cursorTrailColor = Color3.fromHSV(hue, saturation, value)

    self.MouseOverlay = Instance.new("ScreenGui"); self.MouseOverlay.Parent = Knit.Player.PlayerGui

    self.OverlayCursor = Instance.new("ImageLabel"); self.OverlayCursor.Parent = self.MouseOverlay

    self.OverlayCursor.Size = UDim2.new(0, 128, 0, 128)
    self.OverlayCursor.BackgroundTransparency = 1
    self.OverlayCursor.Position = UDim2.new(.5, 0, .5, 0)
    self.OverlayCursor.AnchorPoint = Vector2.new(0.5, 0.5)
    self.OverlayCursor.Image = "rbxassetid://13783067565"
    self.OverlayCursor.ZIndex = 2
    self.OverlayCursor:SetAttribute("Visible", true)

    UserInputService.MouseIconEnabled = false

    self.TrailEmitters = Instance.new("Folder"); self.TrailEmitters.Parent = self.MouseOverlay
    self.TrailEmitters.Name = "TrailEmitterCache"

    self.store.changed:connect(function(newState, _)
        cursorImageColor = newState.options.persistent.CursorImageColor
        hue, saturation, value = newState.options.persistent.CursorImageColor:ToHSV()
        value *= .85
        cursorTrailColor = Color3.fromHSV(hue, saturation, value)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local MouseLocation = UserInputService:GetMouseLocation()
            self.OverlayCursor.Position = UDim2.fromOffset(MouseLocation.X, MouseLocation.Y - 30)
        end
    end)

    self.TimeSinceLastEmitter = tick()

    self.GenerateTrail = true

    if UserInputService.TouchEnabled then
        self.OverlayCursor.Visible = false
        self.GenerateTrail = false
    end

    game:GetService("RunService").Heartbeat:Connect(function()
        if not self.GenerateTrail then
            return
        end

        self.OverlayCursor.ImageColor3 = cursorImageColor
        
        if tick() - self.TimeSinceLastEmitter > .02 then
            self.TimeSinceLastEmitter = tick()

            local temporaryOverlay = Instance.new("ImageLabel")

            temporaryOverlay.Image = "rbxassetid://13783068813"
            temporaryOverlay.BackgroundTransparency = 1
            temporaryOverlay.AnchorPoint = Vector2.new(.5, .5)
            temporaryOverlay.Size = UDim2.fromOffset(80, 80)
            temporaryOverlay.Position = self.OverlayCursor.Position
            temporaryOverlay.Parent = self.TrailEmitters
            temporaryOverlay.ImageColor3 = cursorTrailColor
            temporaryOverlay.ZIndex = 1

            local lifetime = UserInputService:IsKeyDown(Enum.KeyCode.C) and 7 or .5
            local smoothing = TweenService:Create(temporaryOverlay, TweenInfo.new(lifetime), {ImageTransparency = 1})

            smoothing:Play()

            smoothing.Completed:Once(function()
                temporaryOverlay:Destroy()
            end)
        end
    end)
end

local prevValue

function RoactController:ToggleCursor(value: boolean)
    if prevValue == value then
        return
    end

    if UserInputService.TouchEnabled then
        value = false
    end

    if value == nil then value = true end -- default to enabled

    if not value then
        for _, trail in self.TrailEmitters:GetChildren() do
            trail:Destroy()
        end
    end

    local cursorFadeTween = TweenService:Create(self.OverlayCursor, TweenInfo.new(0.4), {
        ImageTransparency = if value then 0 else 1
    })

    cursorFadeTween:Play()

    prevValue = value
    
    self.GenerateTrail = value
end

return RoactController
