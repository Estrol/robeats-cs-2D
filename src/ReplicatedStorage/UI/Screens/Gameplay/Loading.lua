local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local AnimatedNumberLabel = require(game.ReplicatedStorage.UI.Components.Base.AnimatedNumberLabel)
local LoadingWheel = require(game.ReplicatedStorage.UI.Components.Base.LoadingWheel)

local Loading = Roact.Component:extend("Loading")

Loading.defaultProps = {
    OnBack = function()

    end
}

function Loading:render()
    return e(RoundedFrame, {
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(0.4, 0.15),
        AnchorPoint = Vector2.new(0.5, 0.5)
    }, {
        LoadingWheel = e(LoadingWheel, {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.fromScale(0.156, 0.42),
            Size = UDim2.fromScale(0.3, 0.4)
        }),
        LoadingText = e(RoundedTextLabel, {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.fromScale(0.18, 0.42),
            Size = UDim2.fromScale(0.8, 0.452),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextScaled = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = string.format("Please wait for the game to load... [%d]", self.props.SecondsLeft)
        }),
        Back = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.25, 0.21),
            AnchorPoint = Vector2.new(0.5, 0.5),
            HoldSize = UDim2.fromScale(0.25, 0.21),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundColor3 = Color3.fromRGB(230, 19, 19),
            HighlightBackgroundColor3 = Color3.fromRGB(109, 49, 49),
            Position = UDim2.fromScale(0.5, 0.78),
            Text = "Back out",
            TextScaled = true,
            OnClick = self.props.OnBack
        }),
        UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
            AspectRatio = 5,
            DominantAxis = Enum.DominantAxis.Height
        })
    })
end

return Loading
