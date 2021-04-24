local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local Options = require(game.ReplicatedStorage.UI.Screens.Options)

local State = require(game.ReplicatedStorage.State)

return function(target)
    local app = Roact.createElement(RoactRodux.StoreProvider, {
        store = State.Store
    }, {
        App = Roact.createElement(Options)
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end