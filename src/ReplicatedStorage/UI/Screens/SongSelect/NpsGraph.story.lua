local Roact = require(game.ReplicatedStorage.Packages.Roact)
local NpsGraph = require(game.ReplicatedStorage.UI.Screens.SongSelect.NpsGraph)

return function(target)
    local app = Roact.createElement(NpsGraph)
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end