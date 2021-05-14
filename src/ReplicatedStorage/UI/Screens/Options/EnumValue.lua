local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement
local f = Roact.createFragment

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local function noop() end

local EnumValue = Roact.Component:extend("EnumValue")

EnumValue.defaultProps = {
    Size = UDim2.new(1, 0, 0, 80),
    Value = 1,
    ValueNames = {},
    Name = "SettingName",
    OnChanged = noop
}

function EnumValue:render()
    local keybinds = {}

    for i, name in pairs(self.props.ValueNames) do
        local buttonElement = e(RoundedTextButton, {
            Size = UDim2.fromScale(1/#self.props.ValueNames, 1),
            HoldSize = UDim2.fromScale(1/#self.props.ValueNames, 0.8),
            BackgroundColor3 = name == self.props.Value and Color3.fromRGB(24, 180, 207) or Color3.fromRGB(41, 40, 40),
            HighlightBackgroundColor3 = name == self.props.Value and Color3.fromRGB(20, 189, 201) or Color3.fromRGB(31, 30, 30),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            OnClick = function()
                self.props.OnChanged(name, i)
            end,
            LayoutOrder = i,
            Text = name
        })

        table.insert(keybinds, buttonElement)
    end

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
        KeybindContainer = e(RoundedFrame, {
            Size = UDim2.fromScale(0.8, 0.4),
            Position = UDim2.fromScale(0.5, 0.6),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1
        }, {
            UIListLayout = e("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0.01, 0)
            }),
            Keybinds = f(keybinds)
        }),
        UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
            AspectRatio = 8,
            AspectType = Enum.AspectType.ScaleWithParentSize
        })
    })
end

return EnumValue