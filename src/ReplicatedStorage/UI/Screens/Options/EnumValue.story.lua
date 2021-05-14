local Roact = require(game.ReplicatedStorage.Packages.Roact)
local EnumValue = require(game.ReplicatedStorage.UI.Screens.Options.EnumValue)

return function(target)
    local TestComponent = Roact.Component:extend("TestComponent")

    function TestComponent:init()
        self:setState({
            Value = "big"
        })
    end

    function TestComponent:render()
        return Roact.createElement(EnumValue, {
            Value = self.state.Value,
            ValueNames = {"big", "chungus", "big big", "chungus"},
            OnChanged = function(v)
                self:setState({
                    Value = v
                })
            end
        })
    end

    local app = Roact.createElement(TestComponent)
    
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end