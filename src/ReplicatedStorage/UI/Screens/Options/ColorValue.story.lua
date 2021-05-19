  
local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local ColorValue = require(script.Parent.ColorValue)

return function(target)
    Roact.setGlobalConfig({
        elementTracing = true
    })
    
    local TestComponent = Roact.Component:extend("TestComponent")
    
    function TestComponent:init()
        self:setState({
            Value = Color3.new()
        })
    end
    
    function TestComponent:render()
        return e(ColorValue, {
            Value = self.state.Value,
            OnChanged = function(value)
                self:setState({
                    Value = value
                })
            end
        })
    end

    local app = e(TestComponent)

    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end