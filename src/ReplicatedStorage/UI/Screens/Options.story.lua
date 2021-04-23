local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Options = require(game.ReplicatedStorage.UI.Screens.Options)

return function(target)
    local app = Roact.createElement(Options)
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end