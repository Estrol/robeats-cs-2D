local Roact = require(game.ReplicatedStorage.Packages.Roact)
local BoolValue = require(game.ReplicatedStorage.UI.Screens.Options.BoolValue)

return function(target)
    local app = Roact.createElement(BoolValue)
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end