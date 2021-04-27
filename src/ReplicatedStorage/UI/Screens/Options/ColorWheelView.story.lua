local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local ColorWheelView = require(script.Parent.ColorWheelView)

return function(target)
    
    local app = e(ColorWheelView, {
        pointerPosition = UDim2.new(0.5, 0, 0.5, 0);
    })

    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end