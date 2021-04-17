local Roact = require(game.ReplicatedStorage.Packages.Roact)
local SongButtonLayout = require(game.ReplicatedStorage.Client.Components.Screens.SongSelect.SongButtonLayout)

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local Story = require(game.ReplicatedStorage.Shared.Story)

local SongButtonLayoutApp = Story:new()

function SongButtonLayoutApp:render()
    return Roact.createElement(SongButtonLayout, {
        Size = UDim2.new(1,0,1,0)
    })
end

return SongButtonLayoutApp
