local Roact = require(game.ReplicatedStorage.Packages.Roact)
local SongList = require(game.ReplicatedStorage.UI.Screens.SongSelect.SongList)

return function(target)
    local app = Roact.createElement(SongList)
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end
