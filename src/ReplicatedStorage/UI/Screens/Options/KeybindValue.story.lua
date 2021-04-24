local Roact = require(game.ReplicatedStorage.Packages.Roact)
local KeybindValue = require(game.ReplicatedStorage.UI.Screens.Options.KeybindValue)

local Llama = require(game.ReplicatedStorage.Packages.Llama)

return function(target)
    local TestComponent = Roact.Component:extend("TestComponent")

    function TestComponent:init()
        self:setState({
            someKeybindsLol = {
                Enum.KeyCode.World18,
                Enum.KeyCode.World18,
                Enum.KeyCode.World18,
                Enum.KeyCode.World18
            }
        })
    end

    function TestComponent:render()
        return Roact.createElement(KeybindValue, {
            Values = self.state.someKeybindsLol,
            OnChanged = function(index, value)
                self:setState(function(state)
                    return {
                        someKeybindsLol = Llama.Dictionary.join(state.someKeybindsLol, {
                            [index] = value
                        })
                    }
                end)
            end
        })
    end

    local app = Roact.createElement(TestComponent)
    
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end