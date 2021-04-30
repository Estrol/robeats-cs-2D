local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local MainMenu = require(script.Parent.MainMenu)

return function(target)

    local app = e(MainMenu)

    local handle = Roact.mount(app, target)

    return function ()
        Roact.unmount(handle)
    end
end