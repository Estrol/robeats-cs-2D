local Roact = require(game.ReplicatedStorage.Packages.Roact)
local ModSelection = require(game.ReplicatedStorage.UI.Screens.SongSelect.ModSelection)

local Mods = require(game.ReplicatedStorage.RobeatsGameCore.Enums.Mods)

return function(target)
    local Roact = require(game.ReplicatedStorage.Packages.Roact)
    local e = Roact.createElement
    
    local TestComponent = Roact.Component:extend("TestComponent")
    
    function TestComponent:init()
        self:setState({
            activeMods = { Mods.Mirror },
            visible = true
        })
    end
    
    function TestComponent:render()
        return Roact.createElement(ModSelection, {
            ActiveMods = self.state.activeMods,
            OnModSelection = function(mods)
                self:setState({
                    activeMods = mods
                })
            end,
            Visible = self.state.visible,
            OnBackClicked = function()
                self:setState({
                    visible = false
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
