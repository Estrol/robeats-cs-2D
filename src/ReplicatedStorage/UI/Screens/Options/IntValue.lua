local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local function noop() end

local IntValue = Roact.Component:extend("IntValue")

IntValue.defaultProps = {
    Size = UDim2.new(0.98, 0, 0, 80),
    Value = 0,
    Name = "SettingName",
    OnChanged = noop,
    FormatValue = function(value)
        return value
    end
}

function IntValue:render()
    return e(RoundedFrame, {
        Size = self.props.Size,
        Position = self.props.Position,
        BackgroundColor3 =  Color3.fromRGB(24, 68, 78)
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
            Size = UDim2.fromScale(0.35, 0.55),
            Position = UDim2.fromScale(0.05, 0.6),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(37, 37, 37),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = self.props.FormatValue(self.props.Value),
            TextScaled = true
        }),
        Subtract = e(RoundedTextButton, {
            OnClick = function()
                self.props.OnChanged(self.props.Value - 1)
            end,
            BackgroundTransparency = 1,
            BackgroundImage = "rbxassetid://1588248423",
            Size = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.65, 0.6),
            BackgroundImageColor3 = Color3.fromRGB(221, 40, 16),
            ZIndex = 3,
            TextScaled = true,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "-"
        }, {
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 1
            })
        }),
        Add = e(RoundedTextButton, {
            OnClick = function()
                self.props.OnChanged(self.props.Value + 1)
            end,
            BackgroundTransparency = 1,
            BackgroundImage = "rbxassetid://1588248423",
            Size = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.85, 0.6),
            BackgroundImageColor3 = Color3.fromRGB(16, 221, 33),
            ZIndex = 3,
            TextScaled = true,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "+"
        }, {
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 1
            })
        })
    })
end

return IntValue