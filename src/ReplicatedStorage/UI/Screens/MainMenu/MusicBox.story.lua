local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local MusicBox = script.Parent.MusicBox

return function (target)
    local app = e(MusicBox, {
        Position = UDim2.fromScale(0.25, 0.02),
        SongKey = 1
    })

    local handle = Roact.mount(app, target)

    return function ()
        Roact.unmount(handle)
    end
end