local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRouter = require(game.ReplicatedStorage.Packages.RoactRouter)
local Delete = require(game.ReplicatedStorage.UI.Screens.Moderation.Delete)

return function(target)
    local history = RoactRouter.History.new()

    history:push("/", {
        scoreId = "big chungus"
    })

    local router = Roact.createElement(RoactRouter.Router, {
        history = history
    }, {
        Delete = Roact.createElement(RoactRouter.Route, {
            always = true,
            component = Delete
        })
    })

    local handle = Roact.mount(router, target)

    return function()
        Roact.unmount(handle)
    end
end