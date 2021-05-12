local Roact = require(game.ReplicatedStorage.Packages.Roact)
local MultipleChoiceValue = require(game.ReplicatedStorage.UI.Screens.Options.MultipleChoiceValue)

local Llama = require(game.ReplicatedStorage.Packages.Llama)

return function(target)
    local TestComponent = Roact.Component:extend("TestComponent")

    function TestComponent:init()
        self:setState({
            someOptionsLol = { false, false, true, false }
        })
    end

    function TestComponent:render()
        return Roact.createElement(MultipleChoiceValue, {
            Values = self.state.someOptionsLol,
            ValueNames = {"big", "chungus", "big big", "chungus"},
            OnChanged = function(i, v)
                local newOptionsLol = {
                    self.state.someOptionsLol[1],
                    self.state.someOptionsLol[2],
                    self.state.someOptionsLol[3],
                    self.state.someOptionsLol[4]
                }

                newOptionsLol[i] = v

                self:setState({
                    someOptionsLol = newOptionsLol
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