local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local Maid = require(game.ReplicatedStorage.Knit.Util.Maid)

local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)

local SongInfoDisplay = require(script.SongInfoDisplay)
local SongList = require(script.SongList)
local Leaderboard = require(script.Leaderboard)

local Configuration = require(game.ReplicatedStorage.Configuration)

local SongSelect = Roact.Component:extend("SongSelect")

function SongSelect:init()
    self:setState({
        selectedSongKey = 1,
        rate = 100
    })

    self.maid = Maid.new()

    local onConfigurationChanged = Configuration.Changed:Connect(function(prefs)
        self:setState({
            rate = prefs.SongRate
        })
    end)

    local onUprateKeyPressed = SPUtil:bind_to_key(Enum.KeyCode.Equals, function()
        Configuration:set({"SongRate"}, function(_cur_song_rate)
            return _cur_song_rate + 5
        end)
    end)

    local onDownrateKeyPressed = SPUtil:bind_to_key(Enum.KeyCode.Minus, function()
        Configuration:set({"SongRate"}, function(_cur_song_rate)
            return _cur_song_rate - 5
        end)
    end)

    self.maid:GiveTask(onConfigurationChanged)
    self.maid:GiveTask(onUprateKeyPressed)
    self.maid:GiveTask(onDownrateKeyPressed)
end

function SongSelect:render()
    return e(RoundedFrame, {

    }, {
        SongInfoDisplay = e(SongInfoDisplay, {
            Size = UDim2.fromScale(0.985, 0.2),
            Position = UDim2.fromScale(0.01, 0.01),
            SongKey = self.state.selectedSongKey,
            SongRate = self.state.rate
        }),
        SongList = e(SongList, {
            Size = UDim2.fromScale(0.45, 0.77),
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.fromScale(0.995, 0.985),
            OnSongSelected = function(key)
                self:setState({
                    selectedSongKey = key
                })
            end
        }),
        Leaderboard = e(Leaderboard, {
            Size = UDim2.fromScale(0.35, 0.7),
            Position = UDim2.fromScale(0.02, 0.22),
            SongKey = self.state.selectedSongKey
        }),
        PlayButton = e(RoundedTextButton, {
            Position = UDim2.fromScale(0.02, 0.935),
            Size = UDim2.fromScale(0.1, 0.05),
            HoldSize = UDim2.fromScale(0.1, 0.045),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            HighlightBackgroundColor3 = Color3.fromRGB(70, 170, 24),
            TextScaled = true,
            Text = "Play!",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            OnClick = function()
                self.props.history:push("/play", {
                    songKey = self.state.selectedSongKey,
                    songRate = self.state.rate
                })
            end
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 17
            })
        })
    })
end

function SongSelect:willUnmount()
    self.maid:DoCleaning()
end

return SongSelect