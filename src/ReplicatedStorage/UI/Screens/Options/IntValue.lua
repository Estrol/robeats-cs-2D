local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedImageButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageButton)

local function noop() end

local IntValue = Roact.Component:extend("IntValue")

IntValue.defaultProps = {
    Size = UDim2.new(1, 0, 0, 80),
    Value = 0,
    MaxValue = math.huge,
    MinValue = -math.huge,
    Name = "SettingName",
    OnChanged = noop,
    incrementValue = 1;
    FormatValue = function(value)
        return value
    end
}

function IntValue:render()
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
        Value = e(RoundedTextLabel, {
            Size = UDim2.fromScale(0.38, 0.55),
            Position = UDim2.fromScale(0.3, 0.6),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(37, 37, 37),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = self.props.FormatValue(self.props.Value),
            TextScaled = true,
            CornerRadius = UDim.new(0, 12),
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 20,
                MinTextSize = 12
            })
        }),
        Subtract = e(RoundedImageButton, {
            OnClick = function()
                if (self.props.Value - self.props.incrementValue) >= self.props.MinValue then
                    self.props.OnChanged(self.props.Value - self.props.incrementValue)
                else
                    self.props.OnChanged(self.props.MinValue)
                end
            end,
            BackgroundTransparency = 1,
            Image = "rbxassetid://1588248423",
            Size = UDim2.fromScale(0.5, 0.5),
            HoldSize = UDim2.fromScale(0.54, 0.54),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.2, 0.6),
            ImageColor3 = Color3.fromRGB(90, 19, 10),
            HighlightImageColor3 = Color3.fromRGB(168, 42, 25),
            ZIndex = 3,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 20,
            Text = "-"
        }, {
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 1
            })
        }),
        Add = e(RoundedImageButton, {
            OnClick = function()
                if (self.props.Value + self.props.incrementValue) <= self.props.MaxValue then
                    self.props.OnChanged(self.props.Value + self.props.incrementValue)
                else
                    self.props.OnChanged(self.props.MaxValue)
                end
            end,
            BackgroundTransparency = 1,
            Image = "rbxassetid://1588248423",
            Size = UDim2.fromScale(0.5, 0.5),
            HoldSize = UDim2.fromScale(0.54, 0.54),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.78, 0.6),
            ImageColor3 = Color3.fromRGB(9, 83, 15),
            HighlightImageColor3 = Color3.fromRGB(20, 189, 34),
            ZIndex = 3,
            TextScaled = false,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 20,
            Text = "+"
        }, {
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 1
            })
        }),
        UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
            AspectRatio = 8,
            AspectType = Enum.AspectType.ScaleWithParentSize
        })
    })
end

return IntValue