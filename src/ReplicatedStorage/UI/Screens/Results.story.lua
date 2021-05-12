local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRouter = require(game.ReplicatedStorage.Packages.RoactRouter)
local Results = require(game.ReplicatedStorage.UI.Screens.Results)

return function(target)
    local history = RoactRouter.History.new()
    history:push("/", {
        Score = 900000,
        Accuracy = 96,
        Rating = 67.85,
        MaxChain = 0,
        Marvelouses = 0,
        Perfects = 0,
        Greats = 0,
        Goods = 0,
        Bads = 0,
        Misses = 0,
        Hits = {},
        Rate = 100,
        SongKey = 1,
        PlayerName = "lol",
        TimePlayed = 0
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