local StarterPlayer = game:GetService("StarterPlayer")
local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local Skin = require(game.ReplicatedStorage.UI.Screens.Options.Skin)

return function(target)
    local State = require(game.ReplicatedStorage.State)

    local app = Roact.createElement(Skin)

    local wrappedComponent = Roact.createElement(RoactRodux.StoreProvider, {
        store = State.Store
    }, {
        App = app
    })

    local handle = Roact.mount(wrappedComponent, target)

    return function()
        Roact.unmount(handle)
    end
end