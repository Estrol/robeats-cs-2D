local Roact = require(game.ReplicatedStorage.Packages.Roact)
local ListLayout = require(script.Parent.ListLayout)

return function(target)
    local children = {}

    for i = 1, 5 do
        children[i] = Roact.createElement("TextLabel", {
            Size = UDim2.new(0.8, 0, 0, 90),
            Text = string.format("Element #%d", i)
        })
    end

    local app = Roact.createElement("Frame", {
        Size = UDim2.fromScale(1, 1)
    }, {
        List = Roact.createElement(ListLayout, {
            Size = UDim2.fromScale(1, 1),
            StartAt = 50,
            Padding = UDim.new(0, 0)
        }, children)
    })

    local handle = Roact.mount(app, target)

    return function()
        Roact.unmount(handle)
    end
end