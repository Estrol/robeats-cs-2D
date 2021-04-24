local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Rodux = require(game.ReplicatedStorage.Packages.Rodux)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local e = Roact.createElement
local f = Roact.createFragment
local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local Actions = require(game.ReplicatedStorage.Actions)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedAutoScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedAutoScrollingFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local IntValue = require(script.IntValue)

local Options = Roact.Component:extend("Options")

Options.categoryList = { "⚙ General", "🤮 Eww" }

function Options:init()
    self:setState({
        selectedCategory = 1
    })
end

function Options:getSettingElements()
    local elements = {}

    SPUtil:switch(self.state.selectedCategory):case(1, function()
        elements.NoteSpeed = e(IntValue, {
            Value = self.props.options.NoteSpeed,
            OnChanged = function(value)
                self.props.setOption("NoteSpeed", value)
            end,
            FormatValue = function(value)
                if value >= 0 then
                    return string.format("+%d", value)
                end
                return string.format("%d", value)
            end,
            Name = "Note Speed"
        })

        elements.AudioOffset = e(IntValue, {
            Value = self.props.options.AudioOffset,
            OnChanged = function(value)
                self.props.setOption("AudioOffset", value)
            end,
            Name = "Audio Offset",
            FormatValue = function(value)
                return string.format("%d ms", value)
            end
        })
    end):case(2, function()
        elements.Ew = e(IntValue, {
            Value = self.props.options.AudioOffset,
            OnChanged = function(value)
                
            end,
            Name = "Ewwww",
            FormatValue = function(value)
                return string.format("%d ms", value)
            end
        })
    end)

    return elements
end

function Options:render()
    local options = self:getSettingElements()

    local categories = {}

    for i, category in ipairs(self.categoryList) do
        local categoryButton = e(RoundedTextButton, {
            Size = UDim2.new(1, 0, 0, 50),
            HoldSize = UDim2.new(1, 0, 0, 53),
            BackgroundColor3 = i == self.state.selectedCategory and Color3.fromRGB(48, 168, 184) or Color3.fromRGB(20, 20, 20),
            Text = string.format("  - %s", category),
            TextScaled = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            LayoutOrder = i,
            OnClick = function()
                self:setState({
                    selectedCategory = i
                })
            end
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 20,
                MinTextSize = 12
            }),
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 5
            })
        })

        table.insert(categories, categoryButton)
    end

    return e(RoundedFrame, {
        Size = UDim2.fromScale(1, 1)
    }, {
        SettingsContainer = e(RoundedAutoScrollingFrame, {
            Size = UDim2.fromScale(0.3, 0.8),
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.44, 0.5),
            BackgroundColor3 = Color3.fromRGB(36, 36, 36),
            UIListLayoutProps = {
                Padding = UDim.new(0, 4),
            }
        }, {
            Options = f(options)
        }),
        SettingsCategoriesContainer = e(RoundedAutoScrollingFrame, {
            Size = UDim2.fromScale(0.2, 0.8),
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.22, 0.5),
            BackgroundColor3 = Color3.fromRGB(36, 36, 36),
            UIListLayoutProps = {
                Padding = UDim.new(0, 4),
            }
        }, {
            CategoryButtons = f(categories)
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

return RoactRodux.connect(function(state)
    return {
        options = state.options.persistent
    }
end,
function(dispatch)
    return {
        setOption = function(...)
            dispatch(Actions.setPersistentOption(...))
        end
    }
end)(Options)