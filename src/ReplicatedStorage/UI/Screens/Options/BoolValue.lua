local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local function noop() end

local BoolValue = Roact.Component:extend("BoolValue")

BoolValue.defaultProps = {
    Size = UDim2.new(1, 0, 0, 80),
    Value = false,
    Name = "SettingName",
    OnChanged = noop,
    FormatValue = function(value)
        return value
    end
}

function BoolValue:render()
    return e(RoundedFrame, {
        Size = self.props.Size,
        Position = self.props.Position,
        BackgroundColor3 =  Color3.fromRGB(25, 26, 26),
        LayoutOrder = self.props.LayoutOrder
    }, {
        Name = e(RoundedTextLabel, {
            Size = UDim2.fromScale(0.35, 0.2),
            Position = UDim2.fromScale(0.05, 0.07),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Text = self.props.Name,
            TextScaled = true
        }),
        Toggle = e(RoundedTextButton, {
            OnClick = function()
                self.props.OnChanged(not self.props.Value)
            end,
            BackgroundColor3 = self.props.Value and Color3.fromRGB(43, 190, 6) or Color3.fromRGB(233, 10, 10),
            HighlightBackgroundColor3 = self.props.Value and Color3.fromRGB(30, 109, 10) or Color3.fromRGB(119, 18, 18),
            Size = UDim2.fromScale(0.5, 0.5),
            HoldSize = UDim2.fromScale(0.54, 0.54),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.6),
            ZIndex = 3,
            TextScaled = false,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 20,
            Text = self.props.Value and "ON" or "OFF"
        }),
        UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
            AspectRatio = 8,
            AspectType = Enum.AspectType.ScaleWithParentSize
        })
    })
end

return BoolValue