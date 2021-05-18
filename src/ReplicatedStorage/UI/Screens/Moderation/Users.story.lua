local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Users = require(game.ReplicatedStorage.UI.Screens.Moderation.Users)

return function(target)
    local app = Roact.createElement(Users)
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end