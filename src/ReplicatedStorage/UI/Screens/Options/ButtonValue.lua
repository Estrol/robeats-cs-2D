local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local function noop() end

local ButtonValue = Roact.Component:extend("ButtonValue")

ButtonValue.defaultProps = {
    Size = UDim2.new(1, 0, 0, 80),
    Name = "SettingName",
    ButtonText = "ButtonText",
    OnClick = noop
}

function ButtonValue:render()
    return e(RoundedFrame, {
        Size = self.props.Size,
        Position = self.props.Position,
        BackgroundColor3 =  Color3.fromRGB(25, 26, 26),
        LayoutOrder = self.props.LayoutOrder
    }, {
        Name = e(RoundedTextLabel, {
            Size = UDim2.fromScale(0.7, 0.2),
            Position = UDim2.fromScale(0.05, 0.07),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Text = self.props.Name,
            TextScaled = true
        }),
        Button = e(RoundedTextButton, {
            OnClick = self.props.OnClick,
            BackgroundColor3 = Color3.fromRGB(49, 49, 49),
            HighlightBackgroundColor3 = Color3.fromRGB(39, 39, 39),
            Size = UDim2.fromScale(0.5, 0.45),
            HoldSize = UDim2.fromScale(0.54, 0.54),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.6),
            ZIndex = 3,
            TextScaled = false,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 20,
            Text = self.props.ButtonText
        }),
        UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
            AspectRatio = 8,
            AspectType = Enum.AspectType.ScaleWithParentSize
        })
    })
end

return ButtonValue