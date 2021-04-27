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
local KeybindValue = require(script.KeybindValue)

local Options = Roact.Component:extend("Options")

Options.categoryList = {"⚙ General", "➕ Extra" }

function noop() end

function Options:init()
    self:setState({
        selectedCategory = 1
    })
end

function Options:getSettingElements()
    local elements = {}

    SPUtil:switch(self.state.selectedCategory):case(1, function()
        --field of view
        elements.FOV = e(IntValue, {
            Value = self.props.options.FOV;
            OnChanged = function(value)
                self.props.setOption("FOV", value)
            end;

            Name = "Field of View (FOV)";

            FormatValue = function(value)
                return string.format("%d", value)
            end;

            LayoutOrder = 4
        });

        --Notespeed
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
            Name = "Note Speed",
            LayoutOrder = 3
        })

        --Audio Offset
        elements.AudioOffset = e(IntValue, {
            Value = self.props.options.AudioOffset,
            OnChanged = function(value)
                self.props.setOption("AudioOffset", value)
            end,
            Name = "Audio Offset",
            FormatValue = function(value)
                return string.format("%d ms", value)
            end,
            LayoutOrder = 2
        })
        --Keybinds

        elements.InGameKeybinds = e(KeybindValue, {
            Values = {
                self.props.options.Keybind1,
                self.props.options.Keybind2,
                self.props.options.Keybind3,
                self.props.options.Keybind4
            },
            Name = "In-Game Keybinds",
            OnChanged = function(index, value)
                self.props.setOption(string.format("Keybind%d", index), value)
            end,
            LayoutOrder = 1
        });
    end)

    --extras
    SPUtil:switch(self.state.selectedCategory):case(2, function()
        elements.TimeOfDay = e(IntValue, {
            Value = self.props.options.TimeOfDay,
            OnChanged = function(value)
                self.props.setOption("TimeOfDay", value)
            end,
            Name = "Time of Day",
            FormatValue = function(value)
                return string.format("%d", value)
            end,
            LayoutOrder = 1
        })
    end)

    return elements
end

function Options:render()
    local options = self:getSettingElements()

    local categories = {}

    for i, category in ipairs(self.categoryList) do
        local backgroundColor3
        local highlightBackgroundColor3

        if i == self.state.selectedCategory then
            backgroundColor3 = Color3.fromRGB(5, 64, 71)
            highlightBackgroundColor3 = Color3.fromRGB(17, 110, 121)
        else
            backgroundColor3 = Color3.fromRGB(20, 20, 20)
            highlightBackgroundColor3 = Color3.fromRGB(48, 45, 45)
        end

        local categoryButton = e(RoundedTextButton, {
            Size = UDim2.new(1, 0, 0, 50),
            HoldSize = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = backgroundColor3,
            HighlightBackgroundColor3 = highlightBackgroundColor3,
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
                AspectRatio = 5,
                AspectType = Enum.AspectType.ScaleWithParentSize
            })
        })

        table.insert(categories, categoryButton)
    end

    return e(RoundedFrame, {
        Size = UDim2.fromScale(1, 1)
    }, {
        SettingsContainer = e(RoundedAutoScrollingFrame, {
            Size = UDim2.fromScale(0.55, 0.8),
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.32, 0.5),
            BackgroundColor3 = Color3.fromRGB(23, 23, 23),
            UIListLayoutProps = {
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder,
            }
        }, {
            Options = f(options)
        }),
        SettingsCategoriesContainer = e(RoundedAutoScrollingFrame, {
            Size = UDim2.fromScale(0.2, 0.8),
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.1, 0.5),
            BackgroundColor3 = Color3.fromRGB(23, 23, 23),
            UIListLayoutProps = {
                Padding = UDim.new(0, 4),
            }
        }, {
            CategoryButtons = f(categories)
        }),
        BackButton = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.05, 0.05),
            HoldSize = UDim2.fromScale(0.06, 0.06),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.124, 0.95),
            BackgroundColor3 = Color3.fromRGB(212, 23, 23),
            TextColor3 = Color3.fromRGB(255, 255, 255),
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