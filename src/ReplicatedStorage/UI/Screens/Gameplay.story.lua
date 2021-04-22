local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRouter = require(game.ReplicatedStorage.Packages.RoactRouter)
local Gameplay = require(game.ReplicatedStorage.UI.Screens.Gameplay)

return function(target)
    local app = Roact.createElement(RoactRouter.Router, {}, {
        Gameplay = Roact.createElement(RoactRouter.Route, {
            component = Gameplay,
            path = "/",
            exact = true
        })
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end