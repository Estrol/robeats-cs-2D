local Roact = require(game.ReplicatedStorage.Packages.Roact)
local SongSelect = require(game.ReplicatedStorage.UI.Screens.SongSelect)

return function(target)
    local app = Roact.createElement(SongSelect)
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end