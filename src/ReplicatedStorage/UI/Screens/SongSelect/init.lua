local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)

local SongInfoDisplay = require(script.SongInfoDisplay)
local SongList = require(script.SongList)
local Leaderboard = require(script.Leaderboard)

local SongSelect = Roact.Component:extend("SongSelect")

function SongSelect:init()
    self:setState({
        selectedSongKey = 1
    })
end

function SongSelect:render()
    return e(RoundedFrame, {

    }, {
        SongInfoDisplay = e(SongInfoDisplay, {
            Size = UDim2.fromScale(0.985, 0.2),
            Position = UDim2.fromScale(0.01, 0.01),
            SongKey = self.state.selectedSongKey
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
        })
    })
end

return SongSelect