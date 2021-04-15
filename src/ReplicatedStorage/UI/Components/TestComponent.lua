local Roact = require(game.ReplicatedStorage.Packages.Roact)

local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local TestComponent = Roact.Component:extend("TestComponent")

function TestComponent:render()
    return Roact.createElement(RoundedTextButton, {
        Size = UDim2.fromScale(1, 1),
        Text = "Hello World!",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        HighlightBackgroundColor3 = Color3.fromRGB(212, 6, 219),
        OnClick = function()
            print("kek")
        end
    })
end

return TestComponent
