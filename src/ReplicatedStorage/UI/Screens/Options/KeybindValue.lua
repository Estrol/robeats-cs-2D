local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement
local f = Roact.createFragment

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local function noop() end

local KeybindValue = Roact.Component:extend("KeybindValue")

KeybindValue.defaultProps = {
    Size = UDim2.new(1, 0, 0, 80),
    Values = {},
    Name = "SettingName",
    OnChanged = noop
}

function KeybindValue:init()
    self.onKeyPressed = SPUtil:bind_to_key(Enum.KeyCode, function(keyCode)
        if self.state.selectedKeybind then
            self.props.OnChanged(self.state.selectedKeybind, keyCode)
            self:setState({
                selectedKeybind = Roact.None
            })
        end
    end)
end

function KeybindValue:render()
    local keybinds = {}

    for i, button in ipairs(self.props.Values) do
        local buttonElement = e(RoundedTextButton, {
            Size = UDim2.fromScale(1/#self.props.Values, 1),
            HoldSize = UDim2.fromScale(1/#self.props.Values, 0.8),
            BackgroundColor3 = self.state.selectedKeybind == i and Color3.fromRGB(24, 180, 207) or Color3.fromRGB(41, 40, 40),
            HighlightBackgroundColor3 = self.state.selectedKeybind == i and Color3.fromRGB(20, 189, 201) or Color3.fromRGB(31, 30, 30),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            OnClick = function()
                self:setState({
                    selectedKeybind = i
                })
            end,
            Text = button.Name
        })

        table.insert(keybinds, buttonElement)
    end

    return e(RoundedFrame, {
        Size = self.props.Size,
        Position = self.props.Position,
        BackgroundColor3 =  Color3.fromRGB(25, 26, 26)
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
            AnchorPoint = Vector2.new(0.5, 0.5)
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

return KeybindValue