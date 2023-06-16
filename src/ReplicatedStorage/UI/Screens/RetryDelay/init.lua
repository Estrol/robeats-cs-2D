local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Packages.Roact)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)

local e = Roact.createElement

local components = {
    RoundedFrame = require(ReplicatedStorage.UI.Components.Base.RoundedFrame),
    LoadingWheel = require(ReplicatedStorage.UI.Components.Base.LoadingWheel),
    AnimatedNumberLabel = require(ReplicatedStorage.UI.Components.Base.AnimatedNumberLabel),
    RoundedTextLabel = require(ReplicatedStorage.UI.Components.Base.RoundedTextLabel),

}



local RetryDelay = Roact.Component:extend("RetryDelayUI")


function RetryDelay:didMount()
    print("Mounted")
    task.delay(.75, function()
        self.props.history:push("/play")
    end)
end

function RetryDelay:render()
    return e(components.RoundedFrame, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3  = Color3.fromRGB(0, 0, 0)
    },{
        Wheel = e(components.LoadingWheel, {
            RotationSpeed = 1,
            Size = UDim2.fromScale(.1, .1),
            Position = UDim2.fromScale(.5, .5),
            AnchorPoint = Vector2.new(0.5, 0.5)
        }),

        RetryCounter = e(components.AnimatedNumberLabel, {
            FormatValue = function(value)
                return string.format("%02d", value)
            end,
            Value = self.props.RetryCount,
            Size = UDim2.new(0.1, 0, 0, 36),
            Position = UDim2.new(.1, 0, .1, 0),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        })

    })
end

return RoactRodux.connect(function(state)
    return {
        RetryCount = state.options.transient.RetryCount
    }
end)(RetryDelay)