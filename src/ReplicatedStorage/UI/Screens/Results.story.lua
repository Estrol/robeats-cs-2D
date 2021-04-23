local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRouter = require(game.ReplicatedStorage.Packages.RoactRouter)
local Results = require(game.ReplicatedStorage.UI.Screens.Results)

return function(target)
    local history = RoactRouter.History.new()
    history:push("/", {
        score = 900000,
        accuracy = 100,
        rating = 67.85,
        maxCombo = 0
    })

    local app = Roact.createElement(RoactRouter.Router, {
        history = history
    }, {
        Results = Roact.createElement(RoactRouter.Route, {
            component = Results,
            path = "/",
            exact = true
        })
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end