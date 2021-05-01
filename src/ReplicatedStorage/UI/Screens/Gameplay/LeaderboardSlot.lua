local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)

local LeaderboardSlot = Roact.Component:extend("LeaderboardSlot")

LeaderboardSlot.defaultProps = {
    UserId = 0,
    PlayerName = "",
    Rating = 0,
    Accuracy = 0,
    Place = 20,
    IsLocalProfile = false
}


function LeaderboardSlot:render()
    return e(RoundedFrame, {
        Size = UDim2.fromScale(1, 0.13),
        BackgroundColor3 = self.props.IsLocalProfile and Color3.fromRGB(125, 65, 128) or Color3.fromRGB(15, 15, 15),
    }, {
        PlayerAvatar = e(RoundedImageLabel, {
            Size = UDim2.fromScale(0.2, 0.8),
            Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userid=%d&width=420&height=420&format=png", self.props.UserId),
            Position = UDim2.fromScale(0.1, 0.5),
            AnchorPoint = Vector2.new(0, 0.5),
            LayoutOrder = self.props.Place
        }, {
            Place = e(RoundedTextLabel, {
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromScale(0.65, 0.4),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                Text = string.format("#%d", self.props.Place),
                TextScaled = true,
                AnchorPoint = Vector2.new(1, 0.5),
                TextColor3 = Color3.fromRGB(145, 142, 142)
            }),
            PlayerName = e(RoundedTextLabel, {
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(1.25, 0.35),
                Size = UDim2.fromScale(4, 0.4),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                Text = self.props.PlayerName,
                TextScaled = true,
                AnchorPoint = Vector2.new(0, 0.5),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }),
            Data = e(RoundedTextLabel, {
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(1.25, 0.75),
                Size = UDim2.fromScale(4, 0.38),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                Text = string.format("%0.2f | %0.2f%%", self.props.Rating, self.props.Accuracy),
                TextColor3 = Color3.fromRGB(167, 167, 167),
                TextScaled = true,
                AnchorPoint = Vector2.new(0, 0.5),
            }),
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 1
            })
        })
    })
end

return LeaderboardSlot