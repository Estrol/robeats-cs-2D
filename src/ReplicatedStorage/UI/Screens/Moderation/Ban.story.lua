local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRouter = require(game.ReplicatedStorage.Packages.RoactRouter)
local Ban = require(game.ReplicatedStorage.UI.Screens.Moderation.Ban)

return function(target)
    local history = RoactRouter.History.new()

    history:push("/", {
        playerName = "Player1",
        userId = 0
    })

    local router = Roact.createElement(RoactRouter.Router, {
        history = history
    }, {
        Ban = Roact.createElement(RoactRouter.Route, {
            always = true,
            component = Ban
        })
    })

    local handle = Roact.mount(router, target)

    return function()
        Roact.unmount(handle)
    end
end