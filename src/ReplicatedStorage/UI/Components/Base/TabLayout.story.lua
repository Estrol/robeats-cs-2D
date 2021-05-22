local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local TabLayout = require(script.Parent.TabLayout)

local buttons = {
    {
        Text = "a",
        OnActivated = function()
            print("a")
        end
    },
    {
        Text = "b",
        OnActivated = function()
            print("b")
        end
    },
    {
        Text = "c",
        OnActivated = function()
            print("c")
        end
    },
    {
        Text = "d",
        OnActivated = function()
            print("d")
        end
    }
}

return function(target)
    local app = Roact.createElement(TabLayout, {
        Size = UDim2.fromScale(1, 1);
        Buttons = buttons;
    })
    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end

