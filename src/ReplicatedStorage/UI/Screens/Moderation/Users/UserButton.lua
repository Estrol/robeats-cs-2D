local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)

local UserButton = Roact.Component:extend("UserButton")

UserButton.defaultProps = {
    OnKick = function() end,
    OnBan = function() end,
    PlayerName = "Player1",
    UserId = 0
}

function UserButton:init()
    
end

function UserButton:render()
    return e(RoundedFrame, {
        Size = UDim2.new(1, 0, 0, 80),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    }, {
        PlayerAvatar = e(RoundedImageLabel, {
            Size = UDim2.fromScale(0.2, 0.8),
            Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userid=%d&width=420&height=420&format=png", self.props.UserId),
            Position = UDim2.fromScale(0.02, 0.5),
            BackgroundColor3 = Color3.fromRGB(10, 10, 10),
            AnchorPoint = Vector2.new(0, 0.5),
            LayoutOrder = self.props.Place
        }, {
            PlayerName = e(RoundedTextLabel, {
                Size = UDim2.fromScale(5.6, 0.7),
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(1.6, 0.5),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextScaled = true,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Text = self.props.PlayerName
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MaxTextSize = 32
                })
            }),
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 1
            })
        }),
        Ban = e(RoundedTextButton, {
            Position = UDim2.fromScale(0.89, 0.5),
            Size = UDim2.fromScale(0.15, 0.5),
            HoldSize = UDim2.fromScale(0.15, 0.7),
            BackgroundColor3 = Color3.fromRGB(21, 21, 21),
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            TextColor3 = Color3.fromRGB(184, 184, 184),
            Text = "Ban",
            OnClick = function()
                self.props.OnBan(self.props.UserId, self.props.PlayerName)
            end
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 22
            })
        }),
        Kick = e(RoundedTextButton, {
            Position = UDim2.fromScale(0.72, 0.5),
            Size = UDim2.fromScale(0.15, 0.5),
            HoldSize = UDim2.fromScale(0.15, 0.7),
            BackgroundColor3 = Color3.fromRGB(21, 21, 21),
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            TextColor3 = Color3.fromRGB(184, 184, 184),
            Text = "Kick",
            OnClick = function()
                self.props.OnKick(self.props.UserId, self.props.PlayerName)
            end
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 22
            })
        })
    })
end

return UserButton