local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedAutoScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedAutoScrollingFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local Player = Roact.Component:extend("Player")

Player.defaultProps = {
    Name = "Player",
    UserId = 0
}

function Player:init()
    
end

function Player:render()
    return e(RoundedFrame, {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = Color3.fromRGB(19, 19, 19)
    }, {
        UserThumbnail = e(RoundedImageLabel, {
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(13, 13, 13),
            Position = UDim2.fromScale(0.0135, 0.5),
            Size = UDim2.new(0.07, 0, 0.75, 0),
            Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userid=%d&width=420&height=420&format=png", self.props.UserId)
        }, {
            Name = e(RoundedTextLabel, {
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(255, 208, 87),
                TextScaled = true,
                Position = UDim2.fromScale(1.3, 0.04),
                Size = UDim2.fromScale(5, 0.55),
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = (if self.props.IsHost then "👑 " else "") .. self.props.Name
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MaxTextSize = 60
                })
            }),
            Info = e(RoundedTextLabel, {
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(228, 228, 228),
                TextScaled = true,
                Position = UDim2.fromScale(1.3, 0.5),
                Size = UDim2.fromScale(5, 0.55),
                TextXAlignment = Enum.TextXAlignment.Left,
                Text = self.props.Name
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MaxTextSize = 15
                })
            }),
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 1
            })
        })
    })
end

return Player