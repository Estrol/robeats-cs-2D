local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local e = Roact.createElement

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)
local CurveUtil = require(game.ReplicatedStorage.Shared.CurveUtil)
local RobeatsGame = require(game.ReplicatedStorage.RobeatsGameCore.RobeatsGame)
local EnvironmentSetup = require(game.ReplicatedStorage.RobeatsGameCore.EnvironmentSetup)
local GameSlot = require(game.ReplicatedStorage.RobeatsGameCore.Enums.GameSlot)

local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local Gameplay = Roact.Component:extend("Gameplay")

function Gameplay:init()
    self:setState({
        accuracy = 0,
        score = 0
    })

    local _game = RobeatsGame:new(EnvironmentSetup:get_game_environment_center_position())
    _game._input:set_keybinds({
        self.props.options.Keybind1,
        self.props.options.Keybind2,
        self.props.options.Keybind3,
        self.props.options.Keybind4,
    })
    
    _game:load(self.props.options.SongKey, GameSlot.SLOT_1, self.props.options)
    
    _game._loaded:Connect(function()
        _game:start_game()
    end)
    
    self.everyFrameConnection = SPUtil:bind_to_frame(function(dt)
        if _game._audio_manager:get_just_finished() then
            _game:set_mode(RobeatsGame.Mode.GameEnded)
        end

        if _game:get_mode() == RobeatsGame.Mode.GameEnded then
            self.props.history:push("/results", {
                score = self.state.score,
                accuracy = self.state.accuracy
            })
            return
        end

        local dt_scale = CurveUtil:DeltaTimeToTimescale(dt)
        _game:update(dt_scale)

        self.setTimeLeft(_game._audio_manager:get_song_length_ms() - _game._audio_manager:get_current_time_ms())
    end)

    self.onStatsChangedConnection = _game._score_manager:get_on_change():Connect(function()
        self:setState({
            score = _game._score_manager:get_score(),
            accuracy = _game._score_manager:get_accuracy() * 100
        })
    end)

    self.timeLeft, self.setTimeLeft = Roact.createBinding(0)

    self._game = _game
end

function Gameplay:render()
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
            Size = UDim2.fromScale(0.2, 0.05),
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
            Size = UDim2.fromScale(0.2, 0.1),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.fromScale(0.02, 0.98),
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            Text = self.timeLeft:map(function(a)
                return SPUtil:format_ms_time(a)
            end)
        }),
        Back = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.1, 0.05),
            HoldSize = UDim2.fromScale(0.08, 0.05),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundColor3 = Color3.fromRGB(230, 19, 19),
            HighlightBackgroundColor3 = Color3.fromRGB(187, 53, 53),
            Position = UDim2.fromScale(0.02, 0.02),
            Text = "Quit Out",
            OnClick = function()
                self._game:set_mode(RobeatsGame.Mode.GameEnded)
            end
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