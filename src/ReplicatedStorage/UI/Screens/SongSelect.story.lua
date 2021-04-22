local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRouter = require(game.ReplicatedStorage.Packages.RoactRouter)
local SongSelect = require(game.ReplicatedStorage.UI.Screens.SongSelect)

return function(target)
    local app = Roact.createElement(RoactRouter.Router, {}, {
        SongSelect = Roact.createElement(RoactRouter.Route, {
            component = SongSelect,
            path = "/",
            exact = true
            
        })
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end