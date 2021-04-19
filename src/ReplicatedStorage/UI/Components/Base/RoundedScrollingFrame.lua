local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement
local f = Roact.createFragment

local Llama = require(game.ReplicatedStorage.Packages.Llama)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)

local RoundedScrollingFrame = Roact.Component:extend("Button")

RoundedScrollingFrame.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(29, 29, 29);
    ZIndex = 1,
    BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
    TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
    ScrollBarThickness = 2
}

function RoundedScrollingFrame:render()
    local children = Llama.Dictionary.join(self.props[Roact.Children], {
        Corner = e("UICorner", {
            CornerRadius = UDim.new(0,4);
        });
    })

    local props = {}

    for i, v in pairs(self.props) do
        if i ~= Roact.Children then
            props[i] = v
        end
    end

    return f({
        e("ScrollingFrame", props, children),
        e(RoundedFrame, {
            Size = self.props.Size,
            Position = self.props.Position,
            AnchorPoint = self.props.AnchorPoint,
            BackgroundColor3 = self.props.BackgroundColor3,
            BackgroundTransparency = self.props.BackgroundTransparency,
            ZIndex = self.props.ZIndex - 1,
        })
    })
end

return RoundedScrollingFrame