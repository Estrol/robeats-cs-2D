local Roact = require(game.ReplicatedStorage.Packages.Roact)
local SongInfoDisplay = require(game.ReplicatedStorage.UI.Screens.SongSelect.SongInfoDisplay)

return function(target)
    local app = Roact.createElement(SongInfoDisplay, {
        SongKey = 1
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end