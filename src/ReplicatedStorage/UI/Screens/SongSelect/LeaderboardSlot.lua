local Roact = require(game.ReplicatedStorage.Packages.Roact)

local RoundedTextLabel =  require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local LeaderboardSlot = Roact.Component:extend("LeaderboardSlot")

LeaderboardSlot.defaultProps = {
    Data = {
        UserId = 0,
        Place = 0,
        Accuracy = 0,
        Score = 0,
        Marvelouses = 0,
        Mean = 0,
        Rating = 0,
        Perfects = 0,
        Greats = 0,
        Goods = 0,
        Bads = 0,
        Misses = 0,
        Rate = 100,
        PlayerName = "Player1",
    },
    OnClick = function() end
}

LeaderboardSlot.PlaceColors = {
	[1] = Color3.fromRGB(204, 204, 8);
	[2] = Color3.fromRGB(237, 162, 12);
	[3] = Color3.fromRGB(237, 106, 12);
}

LeaderboardSlot.SpreadString = "<font color=\"rgb(125, 125, 125)\">%d</font> <font color=\"rgb(55, 55, 55)\">/</font> <font color=\"rgb(99, 91, 15)\">%d</font> <font color=\"rgb(55, 55, 55)\">/</font> <font color=\"rgb(23, 99, 15)\">%d</font> <font color=\"rgb(55, 55, 55)\">/</font> <font color=\"rgb(15, 39, 99)\">%d</font> <font color=\"rgb(55, 55, 55)\">/</font> <font color=\"rgb(91, 15, 99)\">%d</font> <font color=\"rgb(55, 55, 55)\">/</font> <font color=\"rgb(99, 15, 21)\">%d</font>"

function LeaderboardSlot:render()
    local localUserId = game.Players.LocalPlayer and game.Players.LocalPlayer.UserId or 0

    return Roact.createElement(RoundedTextButton, {
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderMode = Enum.BorderMode.Inset,
        BorderSizePixel = 0,
        Size = UDim2.new(0.982, 0, 0, 25),
        HoldSize = UDim2.new(0.92, 0, 0, 25),
        Text = "",
        LayoutOrder = self.props.Data.Place,
        OnClick = function()
            self.props.OnClick(self.props.Data)
        end
    }, {
        UserThumbnail = Roact.createElement(RoundedImageLabel, {
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(13, 13, 13),
            Position = UDim2.new(0.09, 0, 0.5, 0),
            Size = UDim2.new(0.07, 0, 0.75, 0),
            Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userid=%d&width=420&height=420&format=png", self.props.Data.UserId)
        }, {
            Roact.createElement("UIAspectRatioConstraint", {
                AspectType = Enum.AspectType.ScaleWithParentSize,
                DominantAxis = Enum.DominantAxis.Height,
            }),
            Rating = Roact.createElement(RoundedTextLabel, {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(1.25, 0, 0.6, 0),
                Size = UDim2.new(12.75, 0, 0.35, 0),
                Font = Enum.Font.GothamSemibold,
                Text = string.format("Rating: %0.2f", self.props.Data.Rating),
                TextColor3 = Color3.fromRGB(80, 80, 80),
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
                Position = UDim2.new(4, 0, 0.6, 0),
                Size = UDim2.new(4.25, 0, 0.35, 0),
                Font = Enum.Font.GothamSemibold,
                RichText = true,
                Text = string.format(self.SpreadString, self.props.Data.Marvelouses, self.props.Data.Perfects, self.props.Data.Greats, self.props.Data.Goods, self.props.Data.Bads, self.props.Data.Misses),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                Roact.createElement("UITextSizeConstraint", {
                    MaxTextSize = 12,
                    MinTextSize = 4,
                })
            }),
            --self.props.Data.Marvelouses, self.props.Data.Perfects, self.props.Data.Greats, self.props.Data.Goods, self.props.Data.Bads, self.props.Data.Misses
            Player = Roact.createElement(RoundedTextLabel, {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(1.25, 0, 0, 0),
                Size = UDim2.new(15.3, 0, 0.55, 0),
                Font = Enum.Font.GothamSemibold,
                Text = self.props.Data.PlayerName,
                TextColor3 = (self.props.Data.UserId == localUserId) and Color3.fromRGB(25, 207, 231) or Color3.fromRGB(94, 94, 94),
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                Roact.createElement("UITextSizeConstraint", {
                    MaxTextSize = 49,
                })
            });
            AccuracyRate = Roact.createElement(RoundedTextLabel, {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(8.6, 0, 0.22, 0),
                Size = UDim2.new(2.2, 0, 0.55, 0),
                Font = Enum.Font.GothamSemibold,
                Text = string.format("<font color=\"rgb(181, 189, 181)\">%0.2f%%</font> | %0.2fx", self.props.Data.Accuracy, self.props.Data.Rate / 100),
                RichText = true,
                TextColor3 = Color3.fromRGB(105, 105, 105),
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                Roact.createElement("UITextSizeConstraint", {
                    MaxTextSize = 22,
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
            Text = string.format("#%d", self.props.Data.Place),
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
        })
    })
end

return LeaderboardSlot