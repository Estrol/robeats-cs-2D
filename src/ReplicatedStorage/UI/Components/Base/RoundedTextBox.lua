local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Llama = require(game.ReplicatedStorage.Packages.Llama)

local RoundedTextBox = Roact.Component:extend("Button")

RoundedTextBox.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    Font = Enum.Font.GothamSemibold;
    Text = "RoundedTextBox";
    TextSize = 18;
    BackgroundColor3 = Color3.fromRGB(29, 29, 29);
    CornerRadius = UDim.new(0,4)
}

function RoundedTextBox:render()
    local children = Llama.Dictionary.join(self.props[Roact.Children], {
        Corner = Roact.createElement("UICorner", {
            CornerRadius = self.props.CornerRadius;
        });
    })

    local props = {}

    for i, v in pairs(self.props) do
        if i ~= Roact.Children and i ~= "CornerRadius" then
            props[i] = v
        end
    end

    return Roact.createElement("TextBox", props, children)
end

return RoundedTextBox