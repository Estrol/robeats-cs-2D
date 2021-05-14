local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local RunService = game:GetService("RunService")

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)
local LoadingWheel = require(game.ReplicatedStorage.UI.Components.Base.LoadingWheel)

local PlayerProfile = Roact.Component:extend("PlayerProfile")

function PlayerProfile:init()
    self:setState({
        rank = 0,
        rating = 0,
        accuracy = 0,
        totalMapsPlayed = 0,
        userId = 0,
        playerName = "Player1",
        loaded = false
    })

    if RunService:IsRunning() then
        local Knit = require(game:GetService("ReplicatedStorage").Knit)

        local ScoreService = Knit.GetService("ScoreService")

        ScoreService:GetProfilePromise():andThen(function(profile)
            local rank = ScoreService:GetRank()
            self:setState({
                rank = rank,
                rating = profile.Rating,
                accuracy = profile.Accuracy,
                totalMapsPlayed = profile.TotalMapsPlayed,
                userId = game.Players.LocalPlayer.UserId,
                playerName = game.Players.LocalPlayer.DisplayName,
                loaded = true
            })
        end)
    end
end

function PlayerProfile:render()
    if not self.state.loaded then
        return e(RoundedFrame, {
            Size = UDim2.fromScale(0.4, 0.17),
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.fromScale(0.98, 0.02),
            BackgroundColor3 = Color3.fromRGB(22, 22, 22)
        }, {
            PlayerIcon = e(RoundedImageLabel, {
                Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userid=%d&width=420&height=420&format=png", self.state.userId),
                BackgroundColor3 = Color3.fromRGB(17, 17, 17),
                Size = UDim2.fromScale(0.25, 0.8),
                Position = UDim2.fromScale(0.02, 0.5),
                AnchorPoint = Vector2.new(0, 0.5)
            }, {
                UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                    AspectRatio = 1,
                    DominantAxis = Enum.DominantAxis.Width
                }),
                PlayerName = e(RoundedTextLabel, {
                    Position = UDim2.fromScale(1.2, 0),
                    Size = UDim2.fromScale(2.35, 0.3),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Text = self.state.playerName,
                    TextScaled = true,
                    BackgroundTransparency = 1
                }),
                LoadingWheel = e(LoadingWheel, {
                    Position = UDim2.fromScale(0.5,0.5),
                    Size = UDim2.fromScale(.7, 1);
                    AnchorPoint = Vector2.new(0.5,0.5)
                })
            })
        })
    end

    return e(RoundedFrame, {
        Size = UDim2.fromScale(0.4, 0.17),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.fromScale(0.98, 0.02),
        BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    }, {
        PlayerIcon = e(RoundedImageLabel, {
            Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userid=%d&width=420&height=420&format=png", self.state.userId),
            BackgroundColor3 = Color3.fromRGB(17, 17, 17),
            Size = UDim2.fromScale(0.22, 0.8),
            Position = UDim2.fromScale(0.02, 0.5),
            AnchorPoint = Vector2.new(0, 0.5),
        }, {
           UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
               AspectRatio = 1,
               DominantAxis = Enum.DominantAxis.Width
           }),
           PlayerName = e(RoundedTextLabel, {
               Position = UDim2.fromScale(1.2, 0),
               Size = UDim2.fromScale(2.35, 0.3),
               TextXAlignment = Enum.TextXAlignment.Left,
               TextColor3 = Color3.fromRGB(255, 255, 255),
               Text = self.state.playerName,
               TextScaled = true,
               BackgroundTransparency = 1
           }),
           SkillRating = e(RoundedTextLabel, {
               Position = UDim2.fromScale(1.2, 0.34),
               Size = UDim2.fromScale(2.35, 0.18),
               TextXAlignment = Enum.TextXAlignment.Left,
               TextColor3 = Color3.fromRGB(194, 194, 194),
               Text = string.format("Overall Rating: %0.2f", self.state.rating),
               TextScaled = true,
               BackgroundTransparency = 1
           }),
           Accuracy = e(RoundedTextLabel, {
               Position = UDim2.fromScale(1.2, 0.54),
               Size = UDim2.fromScale(2.35, 0.18),
               TextXAlignment = Enum.TextXAlignment.Left,
               TextColor3 = Color3.fromRGB(194, 194, 194),
               Text = string.format("Average Accuracy: %0.2f%%", self.state.accuracy),
               TextScaled = true,
               BackgroundTransparency = 1
           }),
           TotalMapsPlayed = e(RoundedTextLabel, {
               Position = UDim2.fromScale(1.2, 0.74),
               Size = UDim2.fromScale(2.35, 0.18),
               TextXAlignment = Enum.TextXAlignment.Left,
               TextColor3 = Color3.fromRGB(194, 194, 194),
               Text = string.format("Total Maps Played: %d", self.state.totalMapsPlayed),
               TextScaled = true,
               BackgroundTransparency = 1
           }),
        }),
        Rank = e(RoundedTextLabel, {
            Position = UDim2.fromScale(0.97, 0.92),
            Size = UDim2.fromScale(0.17, 0.4),
            AnchorPoint = Vector2.new(1, 1),
            TextYAlignment = Enum.TextYAlignment.Bottom,
            TextXAlignment = Enum.TextXAlignment.Right,
            TextColor3 = Color3.fromRGB(85, 85, 85),
            Text = string.format("#%d", self.state.rank),
            TextScaled = true,
            BackgroundTransparency = 1
        })
    })
end

return PlayerProfile