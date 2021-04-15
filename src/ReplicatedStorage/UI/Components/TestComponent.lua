local Roact = require(game.ReplicatedStorage.Packages.Roact)

local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local TestComponent = Roact.Component:extend("TestComponent")

function TestComponent:render()
    return Roact.createElement(RoundedTextButton, {
        Size = UDim2.fromScale(1, 1),
        Text = "Hello World!"
    })
end

return TestComponent
