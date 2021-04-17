local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)

local SongInfoDisplay = require(script.SongInfoDisplay)

local SongSelect = Roact.Component:extend("SongSelect")

function SongSelect:init()
    self:setState({
        selectedSongKey = "9c91cb040aa9779af4cc3fb291e0eb72"
    })
end

function SongSelect:render()
    return e(RoundedFrame, {

    }, {
        SongInfoDisplay = e(SongInfoDisplay, {
            Size = UDim2.fromScale(0.6, 0.2),
            Position = UDim2.fromScale(0.01, 0.01),
            SongKey = self.state.selectedSongKey
        })    
    })
end

return SongSelect