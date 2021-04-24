local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local State = require(game.ReplicatedStorage.State)
local SongSelect = require(game.ReplicatedStorage.UI.Screens.SongSelect)

return function(target)
    local app = Roact.createElement(RoactRodux.StoreProvider, {
        store = State.Store
    }, {
        App = Roact.createElement(SongSelect)
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end