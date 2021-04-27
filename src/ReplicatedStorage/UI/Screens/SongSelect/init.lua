local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local e = Roact.createElement

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local Actions = require(game.ReplicatedStorage.Actions)

local Maid = require(game.ReplicatedStorage.Knit.Util.Maid)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local SongInfoDisplay = require(script.SongInfoDisplay)
local SongList = require(script.SongList)
local Leaderboard = require(script.Leaderboard)

local SongSelect = Roact.Component:extend("SongSelect")

function SongSelect:init()
    self.maid = Maid.new()

    local onUprateKeyPressed = SPUtil:bind_to_key(Enum.KeyCode.Equals, function()
        self.props.setSongRate(self.props.options.SongRate + 5)
    end)

    local onDownrateKeyPressed = SPUtil:bind_to_key(Enum.KeyCode.Minus, function()
        self.props.setSongRate(self.props.options.SongRate - 5)
    end)

    local onOptionsKeyPressed = SPUtil:bind_to_key(Enum.KeyCode.O, function()
        self.props.history:push("/options")
    end)

    -- self.maid:GiveTask(onConfigurationChanged)
    self.maid:GiveTask(onUprateKeyPressed)
    self.maid:GiveTask(onDownrateKeyPressed)
    self.maid:GiveTask(onOptionsKeyPressed)
end

function SongSelect:render()
    return e(RoundedFrame, {

    }, {
        SongInfoDisplay = e(SongInfoDisplay, {
            Size = UDim2.fromScale(0.985, 0.2),
            Position = UDim2.fromScale(0.01, 0.01),
            SongKey = self.props.options.SongKey,
            SongRate = self.props.options.SongRate
        }),
        SongList = e(SongList, {
            Size = UDim2.fromScale(0.57, 0.77),
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.fromScale(0.995, 0.985),
            OnSongSelected = function(key)
                self.props.setSongKey(key)
            end
        }),
        Leaderboard = e(Leaderboard, {
            Size = UDim2.fromScale(0.325, 0.7),
            Position = UDim2.fromScale(0.02, 0.22),
            SongKey = self.props.SongKey
        }),
        PlayButton = e(RoundedTextButton, {
            Position = UDim2.fromScale(0.02, 0.935),
            Size = UDim2.fromScale(0.325, 0.05),
            HoldSize = UDim2.fromScale(0.315, 0.045),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            HighlightBackgroundColor3 = Color3.fromRGB(93, 221, 33),
            TextScaled = true,
            Text = "Play!",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Frequency = 10,
            dampingRatio = 1.5;
            OnClick = function()
                self.props.history:push("/play")
            end
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 20
            })
        })
    })
end

function SongSelect:willUnmount()
    self.maid:DoCleaning()
end

return RoactRodux.connect(function(state, props)
    return Llama.Dictionary.join(props, {
        options = Llama.Dictionary.join(state.options.persistent, state.options.transient)
    })
end, function(dispatch)
    return {
        setSongKey = function(songKey)
            dispatch(Actions.setTransientOption("SongKey", songKey))
        end,
        setSongRate = function(songRate)
            dispatch(Actions.setTransientOption("SongRate", songRate))
        end
    }
end)(SongSelect)