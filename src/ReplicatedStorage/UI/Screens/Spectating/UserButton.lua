local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)

local UserButton = Roact.Component:extend("UserButton")

UserButton.defaultProps = {
    OnSpectate = function() end,
    PlayerName = "Player1",
    UserId = 0,
    SongKey = 1,
    SongRate = 100,
}

function UserButton:init()
    
end

function UserButton:render()
    local data = SongDatabase:get_data_for_key(self.props.SongKey)

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
                Size = UDim2.fromScale(5.6, 0.5),
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(1.2, 0.35),
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
            PlayData = e(RoundedTextLabel, {
                Size = UDim2.fromScale(8.6, 0.3),
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.fromScale(1.2, 0.75),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextScaled = true,
                TextColor3 = Color3.fromRGB(153, 153, 153),
                BackgroundTransparency = 1,
                Text = if data then "Playing " .. data.AudioArtist .. " - " .. data.AudioFilename .. " [" .. string.format("%0.2f", self.props.SongRate / 100) .. "x rate]" else "Playing a custom map",
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MaxTextSize = 32
                })
            }),
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 1
            })
        }),
        Spectate = e(RoundedTextButton, {
            Position = UDim2.fromScale(0.89, 0.5),
            Size = UDim2.fromScale(0.15, 0.5),
            HoldSize = UDim2.fromScale(0.15, 0.7),
            BackgroundColor3 = Color3.fromRGB(21, 21, 21),
            TextScaled = true,
            AnchorPoint = Vector2.new(0.5, 0.5),
            TextColor3 = Color3.fromRGB(184, 184, 184),
            Text = "Spectate",
            OnClick = function()
                self.props.OnSpectate(self.props.UserId, self.props.PlayerName, self.props.SongKey, self.props.SongRate)
            end
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 22
            })
        }),
        UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
            AspectRatio = 10,
            AspectType = Enum.AspectType.ScaleWithParentSize,
            DominantAxis = Enum.DominantAxis.Width,
        })
    })
end

return UserButton