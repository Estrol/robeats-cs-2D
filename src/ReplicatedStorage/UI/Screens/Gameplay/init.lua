local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local e = Roact.createElement

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)
local CurveUtil = require(game.ReplicatedStorage.Shared.CurveUtil)
local RobeatsGame = require(game.ReplicatedStorage.RobeatsGameCore.RobeatsGame)
local EnvironmentSetup = require(game.ReplicatedStorage.RobeatsGameCore.EnvironmentSetup)
local GameSlot = require(game.ReplicatedStorage.RobeatsGameCore.Enums.GameSlot)
local Rating = require(game.ReplicatedStorage.RobeatsGameCore.Enums.Rating)
local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)
local DebugOut = require(game.ReplicatedStorage.Shared.DebugOut)

local Leaderboard = require(script.Leaderboard)

local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local LoadingWheel = require(game.ReplicatedStorage.UI.Components.Base.LoadingWheel)

local Knit = require(game:GetService("ReplicatedStorage").Knit)

local Lighting = game:GetService("Lighting")

local Gameplay = Roact.Component:extend("Gameplay")

function Gameplay:init()
    -- Get the score service

    local ScoreService = Knit.GetService("ScoreService")

    -- Set gameplay state

    self:setState({
        accuracy = 0,
        score = 0,
        chain = 0,
        loaded = false
    })

    -- Set up time left bib

    self.timeLeft, self.setTimeLeft = Roact.createBinding(0)
    
    -- Set up the stage

    local stagePlat = EnvironmentSetup:get_robeats_game_stage()
    stagePlat.Transparency = self.props.options.BaseTransparency
    
    -- Set FOV and Time of Day

    workspace.CurrentCamera.FieldOfView = self.props.options.FOV
    Lighting.TimeOfDay = self.props.options.TimeOfDay

    -- Create the game instance

    local _game = RobeatsGame:new(EnvironmentSetup:get_game_environment_center_position())
    _game._input:set_keybinds({
        self.props.options.Keybind1,
        self.props.options.Keybind2,
        self.props.options.Keybind3,
        self.props.options.Keybind4,
    })
    
    -- Load the map

    _game:load(self.props.options.SongKey, GameSlot.SLOT_1, self.props.options)

    -- Bind the game loop to every frame
    
    self.everyFrameConnection = SPUtil:bind_to_frame(function(dt)
        if _game._audio_manager:get_just_finished() then
            _game:set_mode(RobeatsGame.Mode.GameEnded)
        end

        -- Handle starting the game if the audio and its data has loaded!

        if _game._audio_manager:is_ready_to_play() and not self.state.loaded then
            self:setState({
                loaded = true
            })
            _game:start_game()
        end

        -- If we have reached the end of the game, trigger cleanup

        if _game:get_mode() == RobeatsGame.Mode.GameEnded then
            self.everyFrameConnection:Disconnect()

            local marvelouses, perfects, greats, goods, bads, misses, maxChain = _game._score_manager:get_end_records()
            local hits = _game._score_manager:get_hits()
            local mean = _game._score_manager:get_mean()
            local rating = Rating:get_rating_from_accuracy(self.props.options.SongKey, self.state.accuracy, self.props.options.SongRate / 100)

            if not self.forcedQuit then
                ScoreService:SubmitScorePromise(
                    SongDatabase:get_md5_hash_for_key(self.props.options.SongKey),
                    rating,
                    self.state.score,
                    marvelouses,
                    perfects,
                    greats,
                    goods,
                    bads,
                    misses,
                    self.state.accuracy,
                    maxChain,
                    mean,
                    self.props.options.SongRate)
                    :andThen(function()
                        local moment = DateTime.now():ToLocalTime()
                        DebugOut:puts("Score submitted at %d:%d:%d", moment.Hour, moment.Minute, moment.Second)
                    end)
            end

            self.props.history:push("/results", {
                Score = self.state.score,
                Accuracy = self.state.accuracy,
                Marvelouses = marvelouses,
                Perfects = perfects,
                Greats = greats,
                Goods = goods,
                Bads = bads,
                Misses = misses,
                MaxChain = maxChain,
                Hits = hits,
                Mean = mean,
                Rating = rating,
                SongKey = self.props.options.SongKey,
                PlayerName = game.Players.LocalPlayer.DisplayName,
                Rate = self.props.options.SongRate
            })
            return
        end

        local dt_scale = CurveUtil:DeltaTimeToTimescale(dt)
        _game:update(dt_scale)

        self.setTimeLeft(_game._audio_manager:get_song_length_ms() - _game._audio_manager:get_current_time_ms())
    end)

    -- Hook into onStatsChanged to monitor when stats change in ScoreManager

    self.onStatsChangedConnection = _game._score_manager:get_on_change():Connect(function()
        self:setState({
            score = _game._score_manager:get_score(),
            accuracy = _game._score_manager:get_accuracy() * 100,
            chain = _game._score_manager:get_chain()
        })
    end)

    -- Expose the game instance to the rest of the component

    self._game = _game
end

function Gameplay:render()
    if not self.state.loaded then
        return Roact.createFragment({
            LoadingWheel = e(LoadingWheel, {
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(0.39, 0.5),
                Size = UDim2.fromScale(0.07, 0.07)
            }),
            LoadingText = e(RoundedTextLabel, {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.54, 0.5),
                Size = UDim2.fromScale(0.2, 0.2),
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 20,
                Text = "Please wait for the game to load..."
            }),
            Back = e(RoundedTextButton, {
                Size = UDim2.fromScale(0.1, 0.05),
                AnchorPoint = Vector2.new(0.5, 0.5),
                HoldSize = UDim2.fromScale(0.08, 0.05),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundColor3 = Color3.fromRGB(230, 19, 19),
                HighlightBackgroundColor3 = Color3.fromRGB(187, 53, 53),
                Position = UDim2.fromScale(0.5, 0.68),
                Text = "Back out",
                OnClick = function()
                    self.forcedQuit = true
                    self._game:set_mode(RobeatsGame.Mode.GameEnded)
                end
            })
        })
    end

    return Roact.createFragment({
        Score = e(RoundedTextLabel, {
            Size = UDim2.fromScale(0.2, 0.07),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.98, 0),
            TextXAlignment = Enum.TextXAlignment.Right,
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Text = string.format("%0d", self.state.score),
            TextScaled = true
        }, {
            UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
                MaxTextSize = 24
            })
        }),
        Accuracy = e(RoundedTextLabel, {
            Size = UDim2.fromScale(0.2, 0.085),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.98, 0.07),
            TextXAlignment = Enum.TextXAlignment.Right,
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Text = string.format("%0.2f%%", self.state.accuracy),
            TextScaled = true
        }, {
            UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
                MaxTextSize = 18
            })
        }),
        TimeLeft = e(RoundedTextLabel, {
            Size = UDim2.fromScale(0.115, 0.035),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.02, 0.98),
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            TextScaled = true,
            Text = self.timeLeft:map(function(a)
                return SPUtil:format_ms_time(a)
            end)
        }),
        Combo = e(RoundedTextLabel, {
            Size = UDim2.fromScale(0.13, 0.07),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.5, 0.57),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            TextScaled = true,
            Text = "x"..self.state.chain
        }),
        Back = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.1, 0.05),
            HoldSize = UDim2.fromScale(0.08, 0.05),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundColor3 = Color3.fromRGB(230, 19, 19),
            HighlightBackgroundColor3 = Color3.fromRGB(187, 53, 53),
            Position = UDim2.fromScale(0.02, 0.02),
            Text = "Back (No save)",
            OnClick = function()
                self.forcedQuit = true
                self._game:set_mode(RobeatsGame.Mode.GameEnded)
            end
        }),
        Leaderboard = e(Leaderboard, {
            SongKey = self.props.options.SongKey,
            LocalRating = Rating:get_rating_from_accuracy(self.props.options.SongKey, self.state.accuracy, self.props.options.SongRate / 100),
            LocalAccuracy = self.state.accuracy
        })
    })
end

function Gameplay:willUnmount()
    self._game:teardown()
    self.everyFrameConnection:Disconnect() 
end

return RoactRodux.connect(function(state, props)
    return Llama.Dictionary.join(props, {
        options = Llama.Dictionary.join(state.options.persistent, state.options.transient)
    })
end)(Gameplay)