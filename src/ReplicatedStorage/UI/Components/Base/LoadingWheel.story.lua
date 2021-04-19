local Roact = require(game.ReplicatedStorage.Packages.Roact)
local LoadingWheel = require(game.ReplicatedStorage.UI.Components.Base.LoadingWheel)

return function(target)
    local app = Roact.createElement(LoadingWheel, {
        Size = UDim2.fromScale(1, 1)
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end