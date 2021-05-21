local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)
local e = Roact.createElement

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)

local ModButton = Roact.Component:extend("ModButton")

ModButton.defaultProps = {
    Name = "Mod",
    ModId = 0,
    OnClick = function() end,
    Color = Color3.fromRGB(82, 82, 82),
    Selected = true
}

function ModButton:init()
    self.motor = Flipper.SingleMotor.new(self.props.Selected and 1 or 0)
    self.motorBinding = RoactFlipper.getBinding(self.motor)
end

function ModButton:didUpdate()
    self.motor:setGoal(Flipper.Spring.new(self.props.Selected and 1 or 0, {
        dampingRatio = 2.5,
        frequency = 8
    }))
end

function ModButton:render()
    return e(RoundedTextButton, {
        Size = UDim2.fromScale(0.2, 0.2),
        HoldSize = UDim2.fromScale(0.3, 0.3),
        Text = self.props.Name,
        HighlightBackgroundColor3 = Color3.fromRGB(56, 56, 56),
        BackgroundColor3 = self.props.Color,
        TextScaled = true,
        OnClick = function()
            self.props.OnClick()
        end,
        ClipsDescendants = true
    }, {
        UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
            AspectRatio = 1
        }),
        UITextSizeConstraint = e("UITextSizeConstraint", {
            MaxTextSize = 20
        }),
        Selected = e(RoundedImageLabel, {
            Image = "rbxassetid://3642321726",
            Size = UDim2.fromScale(0.3, 0.3),
            AnchorPoint = Vector2.new(1, 1),
            Position = self.motorBinding:map(function(a)
                return UDim2.fromScale(SPUtil:lerp(1.35, 0.97, a), 0.95)
            end),
            BackgroundTransparency = 1
        }, {
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 1
            })
        })
    })
end

return ModButton