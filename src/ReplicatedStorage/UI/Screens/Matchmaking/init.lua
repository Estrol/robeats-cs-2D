local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local e = Roact.createElement

local Actions = require(game.ReplicatedStorage.Actions)

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local Matchmaking = Roact.Component:extend("Matchmaking")

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local LoadingWheel = require(game.ReplicatedStorage.UI.Components.Base.LoadingWheel)

local SongInfoDisplay = require(game.ReplicatedStorage.UI.Screens.SongSelect.SongInfoDisplay)

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local Ranking = require(game.ReplicatedStorage.UI.Screens.Results.Ranking)

function Matchmaking:init()
    self:setState({
        Found = false,
        Hash = nil,
        SongRate = nil
    })

    self.props.matchmakingService:GetMatch(self.props.profile.GlickoRating):andThen(function(map)
        self:setState({
            Found = true,
            Hash = map.SongMD5Hash,
            SongRate = map.Rate,
            TimeLeft = 5
        })

        self.props.setSongKey(SongDatabase:get_key_for_hash(self.state.Hash))
        self.props.setSongRate(self.state.SongRate)

        while task.wait(1) do
            self:setState({
                TimeLeft = self.state.TimeLeft - 1
            })

            if self.state.TimeLeft == 0 then
                break
            end
        end

        self.props.matchmakingService:ReportMatch(map):andThen(function()
            self.props.history:push("/play", {
                Ranked = true
            })
        end)
    end)
end

function Matchmaking:render()
    local found = self.state.Found
    local songInfo

    if found then
        songInfo = e(SongInfoDisplay, {
            Position = UDim2.fromScale(0.5, 0.65),
            Size = UDim2.fromScale(0.9, 0.25),
            AnchorPoint = Vector2.new(0.5, 0.5),
            SongKey = SongDatabase:get_key_for_hash(self.state.Hash),
            SongRate = self.state.SongRate,
            ShowRateButtons = false
        })
    end

    return e(RoundedFrame, {

    }, {
        Ranking = e(Ranking, {
            Rating = self.props.profile.GlickoRating,
			Position = UDim2.fromScale(0.5, 0.1),
			Size = UDim2.fromScale(0.5, 0.2),
			AnchorPoint = Vector2.new(0.5, 0)
        }),
        Message = if not found then e(RoundedTextLabel, {
            Position = UDim2.fromScale(0.54, 0.5),
            Size = UDim2.fromScale(0.5, 0.2),
            AnchorPoint = Vector2.new(1, 0.5),
            Text = "Finding map...",
            TextScaled = true,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Right
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 25
            })
        }) else nil,
        LoadingWheel = if not self.state.Found then e(LoadingWheel, {
            Position = UDim2.fromScale(0.57, 0.5),
            Size = UDim2.fromScale(0.1, 0.1),
            AnchorPoint = Vector2.new(0, 0.5)
        }) else nil,
        BackButton = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.05, 0.05),
            HoldSize = UDim2.fromScale(0.06, 0.06),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.04, 0.95),
            BackgroundColor3 = Color3.fromRGB(212, 23, 23),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Back",
            TextSize = 12,
            OnClick = function()
                self.props.history:push("/")
            end
        }),
        MatchFound = if found then e(RoundedTextLabel, {
            Position = UDim2.fromScale(0.5, 0.45),
            Size = UDim2.fromScale(0.5, 0.2),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Text = string.format("Match found! Starting in %d...", self.state.TimeLeft),
            TextScaled = true,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 35
            })
        }) else nil,
        SongInfo = songInfo
    })
end

local Injected = withInjection(Matchmaking, {
    matchmakingService = "MatchmakingService"
})

return RoactRodux.connect(function(state, props)
    return {
        options = Llama.Dictionary.join(state.options.persistent, state.options.transient),
        permissions = state.permissions,
        profile = state.profiles[tostring(game.Players.LocalPlayer.UserId)]
    }
end, function(dispatch)
    return {
        setSongKey = function(songKey)
            dispatch(Actions.setTransientOption("SongKey", songKey))
        end,
        setSongRate = function(songRate)
            dispatch(Actions.setTransientOption("SongRate", songRate))
        end,
        setMods = function(mods)
            dispatch(Actions.setTransientOption("Mods", mods))
        end
    }
end)(Injected)