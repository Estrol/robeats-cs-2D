local Roact = require(game.ReplicatedStorage.Packages.Roact)
local ButtonLayout = require(game.ReplicatedStorage.UI.Components.Base.ButtonLayout)

return function(target)
    local app = Roact.createElement(ButtonLayout, {
        Buttons = {
            { Name = "Hi", OnClick = function() print("die") end},
            { Name = "Hi", OnClick = function() print("die") end }
        }
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end