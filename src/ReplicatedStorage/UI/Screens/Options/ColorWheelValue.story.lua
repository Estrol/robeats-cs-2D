  
local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local ColorWheelValue = require(script.Parent.ColorWheelValue)

return function(target)
    
    local app = e(ColorWheelValue, {
        pointerPosition = UDim2.new(0.5, 0, 0.5, 0);
    })

    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end