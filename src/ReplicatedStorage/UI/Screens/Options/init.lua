local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement
local f = Roact.createFragment

local Configuration = require(game.ReplicatedStorage.Configuration)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local IntValue = require(script.IntValue)

local Options = Roact.Component:extend("Options")

function Options:init()
    self:setState(Configuration.Preferences)

    self.onConfigurationChanged = Configuration.Changed:Connect(function(preferences)
        self:setState(preferences)
    end)
end

function Options:render()
    local options = {}

    options.NoteSpeed = e(IntValue, {
        Value = self.state.NoteSpeed,
        OnChanged = function(value)
            Configuration:set({"NoteSpeed"}, value)
        end,
        Name = "Note Speed"
    })

    options.AudioOffset = e(IntValue, {
        Value = self.state.AudioOffset,
        OnChanged = function(value)
            Configuration:set({"AudioOffset"}, value)
        end,
        Name = "Audio Offset",
        FormatValue = function(value)
            return string.format("%d ms", value)
        end
    })

    return e(RoundedFrame, {
        Size = UDim2.fromScale(1, 1)
    }, {
        SettingsContainer = e(RoundedFrame, {
            Size = UDim2.fromScale(0.7, 0.8),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        }, {
            UIListLayout = e("UIListLayout", {
                HorizontalAlignment = Enum.HorizontalAlignment.Center
            }),
            Options = f(options)
        }),
        BackButton = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.2, 0.05),
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.fromScale(0.01, 0.99),
            BackgroundColor3 = Color3.fromRGB(212, 23, 23),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            HoldSize = UDim2.fromScale(0.2, 0.08),
            Text = "Back",
            TextSize = 12,
            OnClick = function()
                self.props.history:goBack()
            end
        }),
    })
end

function Options:willUnmount()
    self.onConfigurationChanged:Disconnect()
end

return Options