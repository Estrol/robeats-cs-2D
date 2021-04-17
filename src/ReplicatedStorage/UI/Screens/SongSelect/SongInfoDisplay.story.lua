local Roact = require(game.ReplicatedStorage.Packages.Roact)
local SongInfoDisplay = require(game.ReplicatedStorage.UI.Screens.SongSelect.SongInfoDisplay)

return function(target)
    local app = Roact.createElement(SongInfoDisplay, {
        SongKey = "9c91cb040aa9779af4cc3fb291e0eb72"
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end