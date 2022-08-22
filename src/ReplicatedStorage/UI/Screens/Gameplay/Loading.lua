local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedImageButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageButton)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local AnimatedNumberLabel = require(game.ReplicatedStorage.UI.Components.Base.AnimatedNumberLabel)
local LoadingWheel = require(game.ReplicatedStorage.UI.Components.Base.LoadingWheel)

local Loading = Roact.Component:extend("Loading")

Loading.defaultProps = {
    OnBack = function()

    end,
    SecondsLeft = 10
}

function Loading:render()
    return e(RoundedFrame, {
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.5, 0.35),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }, {
        LoadingWheel = e(LoadingWheel, {
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -10),
            Size = UDim2.fromScale(0.3, 0.4)
        }), 
        LoadingText = e(RoundedTextLabel, {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 1),
            Size = UDim2.fromScale(0.8, 0.452),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextScaled = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = string.format("Loading chart... [%d]", self.props.SecondsLeft)
        }),
        Back = e(RoundedTextButton, {  
            Size = UDim2.fromOffset(35, 35),
            HoldSize = UDim2.fromOffset(37, 37),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -1, 0, 1),
            OnClick = self.props.OnBack,
            Text = "x",
            TextColor3 = Color3.fromRGB(231, 76, 31),
            TextScaled = true
        }),
        UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
            AspectRatio = 5,
            DominantAxis = Enum.DominantAxis.Height
        })
    })
end

return Loading
