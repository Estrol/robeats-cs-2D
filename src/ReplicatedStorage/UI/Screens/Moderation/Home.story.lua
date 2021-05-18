local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Home = require(game.ReplicatedStorage.UI.Screens.Moderation.Home)

return function(target)
    local app = Roact.createElement(Home)
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end