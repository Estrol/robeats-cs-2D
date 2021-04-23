local Roact = require(game.ReplicatedStorage.Packages.Roact)
local IntValue = require(game.ReplicatedStorage.UI.Screens.Options.IntValue)

return function(target)
    local app = Roact.createElement(IntValue, {
        Size = UDim2.fromScale(1, 1),
        OnChanged = function(value)
            print(value)
        end
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end