local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRouter = require(game.ReplicatedStorage.Packages.RoactRouter)
local Moderation = require(game.ReplicatedStorage.UI.Screens.Moderation)

return function(target)
    local router = Roact.createElement(RoactRouter.Router, {
        initialEntries = { "/ban" },
        initialIndex = 1
    }, {
        Panel = Roact.createElement(RoactRouter.Route, {
            path = "/:path",
            exact = true,
            component = Moderation
        })
    })

    local handle = Roact.mount(router, target)

    return function()
        Roact.unmount(handle)
    end
end