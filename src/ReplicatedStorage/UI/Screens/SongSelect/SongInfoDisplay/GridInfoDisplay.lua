local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)
local e = Roact.createElement

local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)

local GridInfoDisplay = Roact.Component:extend("GridInfoDisplay")

GridInfoDisplay.defaultProps = {
    Name = "GridInfoDisplay",
    Value = 0,
    FormatValue = function(value)
        return value
    end
}

function GridInfoDisplay:init()
    self.motor = Flipper.SingleMotor.new(0)
    self.motorBinding = RoactFlipper.getBinding(self.motor)
end

function GridInfoDisplay:didUpdate(prevProps)
    if self.props.Value ~= prevProps.Value then
        self.motor:setGoal(Flipper.Instant.new(0))
        self.motor:step(0)
        self.motor:setGoal(Flipper.Spring.new(1, {
            frequency = 2;
            dampingRatio = 2.5;
        }))
    end
end

function GridInfoDisplay:didMount()
    self.motor:setGoal(Flipper.Spring.new(1, {
        frequency = 2;
        dampingRatio = 2.5;
    }))
end

function GridInfoDisplay:render()
    return e(RoundedTextLabel, {
        TextColor3 = Color3.fromRGB(216, 216, 216),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        LayoutOrder = self.props.LayoutOrder,
        Position = self.motorBinding:map(function(a)
            return UDim2.new(0.05*(1-a), 0, 0.35, 0)
        end),
        TextTransparency = self.motorBinding:map(function(a)
            return 1-a
        end);
        Size = UDim2.new(0.18, 0, 0.25, 0),
        Font = Enum.Font.GothamSemibold,
        Text = self.props.FormatValue(self.props.Value),
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.X
    }, {
        UITextSizeConstraint = e("UITextSizeConstraint", {
            MaxTextSize = 17
        })
    });
end

return GridInfoDisplay