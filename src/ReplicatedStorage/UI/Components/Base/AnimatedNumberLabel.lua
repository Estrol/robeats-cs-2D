local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local e = Roact.createElement

local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)

local AnimatedNumberLabel = Roact.Component:extend("AnimatedNumberLabel")

AnimatedNumberLabel.defaultProps = {
    Value = 0,
    FormatValue = function(a)
        return a
    end,
    SpringProps = {
        dampingRatio = 2.5,
        frequency = 9
    }
}

function AnimatedNumberLabel:init()
    self.motor = Flipper.SingleMotor.new(self.props.Value)
    self.motorBinding = RoactFlipper.getBinding(self.motor)
end

function AnimatedNumberLabel:didUpdate()
    self.motor:setGoal(Flipper.Spring.new(self.props.Value, self.props.SpringProps))
end

function AnimatedNumberLabel:render()
    local props = Llama.Dictionary.join(self.props, {
        Text = self.motorBinding:map(function(a)
            return self.props.FormatValue(a)
        end)
    })

    local labelProps = {}

    for k, v in pairs(props) do
        if k ~= "FormatValue" and k ~= "Value" and k ~= Roact.Children and k ~= "SpringProps" then
            labelProps[k] = v
        end
    end

    return e(RoundedTextLabel, labelProps, self.props[Roact.Children])
end

return AnimatedNumberLabel