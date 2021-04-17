local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Slider = require(game.ReplicatedStorage.UI.Components.Base.Slider)

return function(target)
    local SliderValueContainer = Roact.Component:extend("SliderValueContainer")

    function SliderValueContainer:init()
        self:setState({
            percent = 0;
        })
    end

    function SliderValueContainer:render()
        return Roact.createElement(Slider, {
            value = self.state.percent;
            onDrag = function(a)
                self:setState({
                    percent = a
                })  
            end
        })
    end

    local app = Roact.createElement(SliderValueContainer)

    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end