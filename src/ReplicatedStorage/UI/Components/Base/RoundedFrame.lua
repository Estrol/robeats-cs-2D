local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Llama = require(game.ReplicatedStorage.Packages.Llama)

local RoundedFrame = Roact.Component:extend("Button")

RoundedFrame.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(29, 29, 29);
}

function RoundedFrame:render()
    local children = Llama.Dictionary.join(self.props[Roact.Children], {
        Corner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0,4);
        });
    })

    local props = {}

    for i, v in pairs(self.props) do
        if i ~= Roact.Children then
            props[i] = v
        end
    end

    return Roact.createElement("Frame", props, children)
end

return RoundedFrame