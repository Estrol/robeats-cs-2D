local Roact = require(game.ReplicatedStorage.Packages.Roact)

local RoundedTextLabel =  require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)

local LeaderboardSlot = Roact.Component:extend("LeaderboardSlot")

LeaderboardSlot.defaultProps = {
    UserId = 0,
    Place = 0,
    Score = 0,
    Marvelouses = 0,
    Perfects = 0,
    Greats = 0,
    Goods = 0,
    Bads = 0,
    Misses = 0,
    PlayerName = "Player1"
}

LeaderboardSlot.PlaceColors = {
	[1] = Color3.fromRGB(204, 204, 8);
	[2] = Color3.fromRGB(237, 162, 12);
	[3] = Color3.fromRGB(237, 106, 12);
}

LeaderboardSlot.SpreadString = "<font color=\"rgb(181, 189, 181)\">%d</font> <font color=\"rgb(55, 55, 55)\">/</font> <font color=\"rgb(112, 117, 45)\">%d</font> <font color=\"rgb(55, 55, 55)\">/</font> <font color=\"rgb(45, 117, 47)\">%d</font> <font color=\"rgb(55, 55, 55)\">/</font> <font color=\"rgb(45, 79, 117)\">%d</font> <font color=\"rgb(55, 55, 55)\">/</font> <font color=\"rgb(107, 45, 117)\">%d</font> <font color=\"rgb(55, 55, 55)\">/</font> <font color=\"rgb(120, 31, 13)\">%d</font>"

function LeaderboardSlot:render()
    return Roact.createElement("Frame", {
        Name = "LeaderboardSlot",
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderMode = Enum.BorderMode.Inset,
        BorderSizePixel = 0,
        Size = UDim2.new(0.982, 0, 0.3, 25),
        LayoutOrder = self.props.Place
    }, {
        UserThumbnail = Roact.createElement(RoundedImageLabel, {
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.new(0.09, 0, 0.5, 0),
            Size = UDim2.new(0.07, 0, 0.75, 0),
            Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userid=%d&width=420&height=420&format=png", self.props.UserId)
        }, {
            Roact.createElement("UIAspectRatioConstraint", {
                AspectType = Enum.AspectType.ScaleWithParentSize,
                DominantAxis = Enum.DominantAxis.Height,
            }),
            Score = Roact.createElement(RoundedTextLabel, {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(1.25, 0, 0.6, 0),
                Size = UDim2.new(12.75, 0, 0.35, 0),
                Font = Enum.Font.GothamSemibold,
                Text = string.format("Score: %d", self.props.Score),
                TextColor3 = Color3.fromRGB(167, 167, 167),
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                Roact.createElement("UITextSizeConstraint", {
                    MaxTextSize = 29,
                    MinTextSize = 3,
                })
            }),
            Spread = Roact.createElement(RoundedTextLabel, {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(4.15, 0, 0.6, 0),
                Size = UDim2.new(12.7, 0, 0.35, 0),
                Font = Enum.Font.GothamSemibold,
                RichText = true,
                Text = string.format(self.SpreadString, self.props.Marvelouses, self.props.Perfects, self.props.Greats, self.props.Goods, self.props.Bads, self.props.Misses),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                Roact.createElement("UITextSizeConstraint", {
                    MaxTextSize = 29,
                    MinTextSize = 3,
                })
            }),
            --self.props.Marvelouses, self.props.Perfects, self.props.Greats, self.props.Goods, self.props.Bads, self.props.Misses
            Player = Roact.createElement(RoundedTextLabel, {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(1.25, 0, 0, 0),
                Size = UDim2.new(15.3, 0, 0.55, 0),
                Font = Enum.Font.GothamSemibold,
                Text = self.props.PlayerName,
                TextColor3 = Color3.fromRGB(94, 94, 94),
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                Roact.createElement("UITextSizeConstraint", {
                    MaxTextSize = 49,
                })
            });
            Accuracy = Roact.createElement(RoundedTextLabel, {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(9, 0, 0.22, 0),
                Size = UDim2.new(1.5, 0, 0.55, 0),
                Font = Enum.Font.GothamSemibold,
                Text = string.format("%0.2f%%", self.props.Accuracy),
                TextColor3 = Color3.fromRGB(105, 105, 105),
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                Roact.createElement("UITextSizeConstraint", {
                    MaxTextSize = 26,
                    MinTextSize = 7;
                })
            })
        }),

        Place = Roact.createElement(RoundedTextLabel, {
            BackgroundColor3 = Color3.fromRGB(54, 54, 54),
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0.0075, 0.1),
            Size = UDim2.fromScale(0.075, 0.755),
            Font = Enum.Font.GothamBold,
            Text = string.format("#%d", self.props.Place),
            TextColor3 = Color3.fromRGB(71, 71, 70),
            TextScaled = true,
            BackgroundTransparency = 1;
        }, {
            Roact.createElement("UITextSizeConstraint", {
                MaxTextSize = 19,
                MinTextSize = 7,
            }),
        }),
        UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
            AspectRatio = 9,
            AspectType = Enum.AspectType.ScaleWithParentSize,
        }),
        Corner = Roact.createElement("UICorner", {
            CornerRadius = UDim.new(0, 4),
        })
    })
end

return LeaderboardSlot