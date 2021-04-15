local Roact = require(game.ReplicatedStorage.Packages.Roact)

local RoundedFrame = Roact.Component:extend("Button")

RoundedFrame.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(29, 29, 29);
}

function RoundedFrame:render()
    return Roact.createElement("Frame", self.props, {
        Corner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0,4);
        });
        Cdrn = Roact.createFragment(self.props[Roact.Children]);
    })
end

return RoundedFrame