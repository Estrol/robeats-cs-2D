local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local ButtonLayout = Roact.Component:extend("ButtonLayout")

local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)

ButtonLayout.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    Buttons = {},
    ButtonColor = Color3.fromRGB(189, 53, 53),
    Padding = UDim.new(0.0025, 0)
}

function ButtonLayout:init()
    
end

function ButtonLayout:render()
    local children = {}
    
    local num = math.max(5, #self.props.Buttons)

    local slot = 0

    for i, v in ipairs(self.props.Buttons) do
        if v.EmptySlots then
            for _ = 1, v.EmptySlots do
                slot += 1
                table.insert(children, e("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.fromScale(1/num, 0.85),
                    BackgroundTransparency = 1,
                    LayoutOrder = slot
                }))
            end
        else
            table.insert(children, e(RoundedTextButton, {
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.fromScale(1/num, 0.85),
                HoldSize = UDim2.fromScale((1/num)-0.01, 0.85),
                Text = v.Text,
                TextScaled = true,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                OnClick = v.OnClick,
                BackgroundColor3 = v.Color or self.props.ButtonColor,
                HighlightBackgroundColor3 = v.HighlightColor,
                LayoutOrder = slot
            }))
            slot += 1
        end
    end

    return e(RoundedFrame, {
        Size = self.props.Size,
        Position = self.props.Position,
        AnchorPoint = self.props.AnchorPoint,
        ClipsDescendants = true,
        ZIndex = self.props.ZIndex,
        BackgroundColor3 = self.props.BackgroundColor3
    }, {
        Container = e("Frame", {
            Size = UDim2.fromScale(0.985, 1),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
        }, {
            UIListLayout = e("UIListLayout", {
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = self.props.Padding,
                FillDirection = Enum.FillDirection.Horizontal
            }),
            Buttons = Roact.createFragment(children)
        })
    })
end

return ButtonLayout