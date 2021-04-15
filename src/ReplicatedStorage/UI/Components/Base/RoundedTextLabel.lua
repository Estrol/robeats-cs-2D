local Roact = require(game.ReplicatedStorage.Packages.Roact)

local RoundedTextLabel = Roact.Component:extend("Button")

RoundedTextLabel.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    Font = Enum.Font.GothamSemibold;
    Text = "RoundedTextLabel";
    TextSize = 18;
    BackgroundColor3 = Color3.fromRGB(29, 29, 29);
}

function RoundedTextLabel:render()
    return Roact.createElement("TextLabel", self.props, {
        Corner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0,4);
        });
        Cdrn = Roact.createFragment(self.props[Roact.Children]);
    })
end

return RoundedTextLabel