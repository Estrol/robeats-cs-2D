local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement
local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)

local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedScrollingFrame)

local Dropdown = Roact.Component:extend("Dropdown")

Dropdown.defaultProps = {
    OnSelectionChange = function()
        
    end
}

function Dropdown:init()
    self.motor = Flipper.SingleMotor.new(0)
    self.motorBinding = RoactFlipper.getBinding(self.motor)

    self:setState({
        IsOpen = false
    })
end

function Dropdown:didUpdate(_, prevState)
    if prevState.IsOpen ~= self.state.IsOpen then
        self.motor:setGoal(Flipper.Spring.new(
            self.state.IsOpen and 1 or 0,
            {
                dampingRatio = 1.5,
                frequency = 3,
            }
        ))
    end
end

function Dropdown:render()
    local options = self.props.Options or {}
    local selectedOption = self.props.SelectedOption or options[1]

    local menuItems = {}
    for _, option in ipairs(options) do
        table.insert(menuItems, Roact.createElement(RoundedTextButton, {
            Text = option,
            TextColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.5,
            TextScaled = true,
            Size = UDim2.new(1.5, 0, 0, 30) - UDim2.fromOffset(0, 5),
            HoldSize = UDim2.new(1, 0, 0, 32) - UDim2.fromOffset(0, 5),
            BackgroundColor3 = if selectedOption == option then Color3.fromRGB(5, 64, 71) else Color3.fromRGB(17, 17, 17),
            LayoutOrder = _,
            TextXAlignment = Enum.TextXAlignment.Left,
            OnClick = function()
                self.props.OnSelectionChange(option)

                self:setState({
                    IsOpen = not self.state.IsOpen
                })
            end,
        }, {
            UIPadding = e("UIPadding", {
                PaddingLeft = UDim.new(0, 12)
            }),
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 17
            })
        }))
    end

    local dropdownButton = Roact.createElement(RoundedTextButton, {
        Text = "▼ " .. selectedOption,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        HighlightBackgroundColor3 = Color3.fromRGB(10, 10, 10),
        Size = UDim2.new(1, 0, 0, 30),
        HoldSize = UDim2.new(1, 0, 0, 30),
        ZIndex = 2,
        TextXAlignment = Enum.TextXAlignment.Left,
        OnClick = function()
            self:setState({
                IsOpen = not self.state.IsOpen
            })
        end,
    }, {
        UIPadding = e("UIPadding", {
            PaddingLeft = UDim.new(0, 12)
        })
    })

    table.insert(menuItems, e("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder
    }))

    local menu = Roact.createElement(RoundedScrollingFrame, {
        Size = UDim2.fromScale(1, 1) - UDim2.fromOffset(0, 30),
        CanvasSize = UDim2.fromScale(0, 0),
        BackgroundTransparency = 0.5,
        BackgroundColor3 = Color3.new(0, 0, 0),
        Position = self.motorBinding:map(function(value)
            return UDim2.fromScale(0, value - 1) + UDim2.fromOffset(0, 30)
        end),
        ClipsDescendants = true,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 0
    }, menuItems)

    return Roact.createElement("Frame", {
        Position = self.props.Position,
        Size = (self.props.Size or UDim2.fromScale(0.2, 0.3)) + UDim2.fromOffset(0, 30),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
    }, {
        DropdownButton = dropdownButton,
        Menu = menu,
    })
end

return Dropdown
