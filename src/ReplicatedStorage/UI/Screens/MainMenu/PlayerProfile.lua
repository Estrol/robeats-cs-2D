local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local Llama = require(game.ReplicatedStorage.Packages.Llama)

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)
local LoadingWheel = require(game.ReplicatedStorage.UI.Components.Base.LoadingWheel)

local Tier = require(game.ReplicatedStorage.UI.Components.Tier)

local Breakdown = require(game.ReplicatedStorage.UI.Screens.Scores.Breakdown)

local Tiers = require(game.ReplicatedStorage.Tiers)

local PlayerProfile = Roact.Component:extend("PlayerProfile")

PlayerProfile.defaultProps = {
    Position = UDim2.fromScale(0.98, 0.02),
    Size = UDim2.fromScale(0.4, 0.17),
    AnchorPoint = Vector2.new(1, 0)
}

function PlayerProfile:init()
    self.scoreService = self.props.scoreService

    self:setState({
        rank = 0,
        rating = 0,
        accuracy = 0,
        totalMapsPlayed = 0,
        userId = if self.props.UserId then self.props.UserId else if game.Players.LocalPlayer then game.Players.LocalPlayer.UserId else nil,
        playerName = if self.props.PlayerName then self.props.PlayerName else if game.Players.LocalPlayer then game.Players.LocalPlayer.Name else nil,
        loaded = false,
        error = false,
    })

    self.scoreService:GetProfile(self.state.userId):andThen(function(profile)
        if not Llama.isEmpty(profile) then
            local tier = if profile.Rating then Tiers:GetTierFromRating(profile.Rating.Overall) else {}

            self:setState({
                rank = profile.Rank,
                rating = if profile.Rating then profile.Rating else 0,
                accuracy = profile.Accuracy or 0,
                totalMapsPlayed = profile.TotalMapsPlayed or 0,
                tier = tier.name,
                division = tier.division,
                subdivision = tier.subdivision,
                loaded = true,
                error = profile.error,
            })
        else
            self:setState({
                rank = Roact.None,
                loaded = true
            })
        end
    end)
end

function PlayerProfile:render()
    if not self.state.loaded then
        return e(RoundedFrame, {
            Size = self.props.Size,
            AnchorPoint = self.props.AnchorPoint,
            Position = self.props.Position,
            BackgroundColor3 = Color3.fromRGB(22, 22, 22),
            BackgroundTransparency = self.props.BackgroundTransparency
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
                    Size = UDim2.fromScale(3.3, 0.3),
                    RichText = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Text = self.state.playerName,
                    TextScaled = true,
                    Font = Enum.Font.GothamBold,
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
        Size = self.props.Size,
        AnchorPoint = self.props.AnchorPoint,
        Position = self.props.Position,
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        BackgroundTransparency = self.props.BackgroundTransparency
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
               Size = UDim2.fromScale(3.3, 0.3),
               RichText = true,
               TextXAlignment = Enum.TextXAlignment.Left,
               TextColor3 = Color3.fromRGB(255, 255, 255),
               Text = if self.state.tier then string.format("%s <font color=\"#b3b3b3\">[%s]</font>", self.state.playerName, self.state.tier..(if self.state.division then string.format(" %s", string.rep("I", self.state.division)) else "")) else self.state.playerName,
               TextScaled = true,
               Font = Enum.Font.GothamBold,
               BackgroundTransparency = 1
           }),
           SkillRating = e(RoundedTextLabel, {
               Position = UDim2.fromScale(1.2, 0.34),
               Size = UDim2.fromScale(2.35, 0.18),
               TextXAlignment = Enum.TextXAlignment.Left,
               TextColor3 = Color3.fromRGB(194, 194, 194),
               Text = string.format("Overall Rating: %0.2f", if typeof(self.state.rating) == "table" then self.state.rating.Overall else self.state.rating),
               TextScaled = true,
               Font = Enum.Font.Gotham,
               BackgroundTransparency = 1
           }),
           Accuracy = e(RoundedTextLabel, {
               Position = UDim2.fromScale(1.2, 0.54),
               Size = UDim2.fromScale(2.35, 0.18),
               TextXAlignment = Enum.TextXAlignment.Left,
               TextColor3 = Color3.fromRGB(194, 194, 194),
               Text = string.format("Average Accuracy: %0.2f%%", self.state.accuracy),
               TextScaled = true,
               Font = Enum.Font.Gotham,
               BackgroundTransparency = 1
           }),
           TotalMapsPlayed = e(RoundedTextLabel, {
               Position = UDim2.fromScale(1.2, 0.74),
               Size = UDim2.fromScale(2.35, 0.18),
               TextXAlignment = Enum.TextXAlignment.Left,
               TextColor3 = Color3.fromRGB(194, 194, 194),
               Text = string.format("Total Maps Played: %d", self.state.totalMapsPlayed),
               TextScaled = true,
               Font = Enum.Font.Gotham,
               BackgroundTransparency = 1
           }),
           Tier = self.state.tier and e(Tier, {
                imageLabelProps = {
                    Position = UDim2.fromScale(0.01, 1),
                    Size = UDim2.fromScale(0.5, 1),
                    AnchorPoint = Vector2.new(0, 1),
                    BackgroundTransparency = 1,
                    ImageTransparency = 0.1
                },
                tier = self.state.tier,
                division = self.state.division
            })
        }),
        Rank = if self.state.rank and self.props.ShowRank then e(RoundedTextLabel, {
            Position = UDim2.fromScale(0.97, 0.92),
            Size = UDim2.fromScale(0.5, 0.45),
            AnchorPoint = Vector2.new(1, 1),
            TextYAlignment = Enum.TextYAlignment.Bottom,
            TextXAlignment = Enum.TextXAlignment.Right,
            TextColor3 = Color3.fromRGB(85, 85, 85),
            Text = if not self.state.error then string.format("#%d", self.state.rank) else "#???",
            TextScaled = true,
            BackgroundTransparency = 1,
            TextTransparency = 0.4,
            ZIndex = 0
        }) else nil,
        Breakdown = if self.props.ShowBreakdown then e(Breakdown, {
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromScale(0.8, 1),
            AnchorPoint = Vector2.new(0, 0),
            BackgroundTransparency = 1,
            Skillsets = if typeof(self.state.rating) == "table" then self.state.rating else nil,
        }) else nil
    })
end

return withInjection(PlayerProfile, {
    scoreService = "ScoreService"
})