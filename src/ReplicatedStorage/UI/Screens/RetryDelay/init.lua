local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Roact = require(ReplicatedStorage.Packages.Roact)
local RoactRodux = require(ReplicatedStorage.Packages.RoactRodux)

local e = Roact.createElement

local RoundedFrame = require(ReplicatedStorage.UI.Components.Base.RoundedFrame)
local LoadingWheel = require(ReplicatedStorage.UI.Components.Base.LoadingWheel)
local AnimatedNumberLabel = require(ReplicatedStorage.UI.Components.Base.AnimatedNumberLabel)

local RetryDelay = Roact.Component:extend("RetryDelayUI")


function RetryDelay:didMount()
    task.delay(.75, function()
        self.props.history:push("/play")
    end)
end

function RetryDelay:render()
    return e(RoundedFrame, {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3  = Color3.fromRGB(0, 0, 0)
    },{
        Wheel = e(LoadingWheel, {
            RotationSpeed = 1,
            Size = UDim2.fromScale(.1, .1),
            Position = UDim2.fromScale(.5, .5),
            AnchorPoint = Vector2.new(0.5, 0.5)
        }),

        RetryCounter = e(AnimatedNumberLabel, {
            FormatValue = function(value)
                return string.format("Retry count: %d", value)
            end,
            Value = self.props.RetryCount,
            AnchorPoint = Vector2.new(0.5, 1),
            Size = UDim2.fromScale(0.7, 0.06),
            Position = UDim2.fromScale(0.5, 0.4),
            BackgroundTransparency = 1,
            TextScaled = true,
            TextColor3 = Color3.fromRGB(255, 255, 255),
        })

    })
end

return RoactRodux.connect(function(state)
    return {
        RetryCount = state.options.transient.RetryCount
    }
end)(RetryDelay)