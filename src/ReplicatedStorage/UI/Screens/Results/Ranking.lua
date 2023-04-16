local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)

local Tier = require(game.ReplicatedStorage.UI.Components.Tier)

local Tiers = require(game.ReplicatedStorage.Tiers)

local Ranking = Roact.Component:extend("Ranking")

Ranking.defaultProps = {
    Rating = 0,
    Size = UDim2.fromScale(0.5, 0.5),
    Position = UDim2.fromScale(0, 0.5),
    AnchorPoint = Vector2.new(0, 0.5)
}

function Ranking.getDerivedStateFromProps(nextProps, lastState)
    local prevTier = if lastState.rating then Tiers:GetTierFromRating(lastState.rating) else nil
    local tier = Tiers:GetTierFromRating(nextProps.Rating)

    return {
        rating = nextProps.Rating,
        tier = tier.name,
        division = tier.division or Roact.None,
        subdivision = tier.subdivision or Roact.None,
        subdivisionChanged = if prevTier then tier.subdivision ~= prevTier.subdivision else false,
        divisionChanged = if prevTier then tier.division ~= prevTier.division or tier.tierBaseValue ~= prevTier.tierBaseValue else false,
        up = if lastState.rating then nextProps.Rating > lastState.rating else false
    }
end

function Ranking:init()
    self.motor = Flipper.GroupMotor.new({
        rankUp = 0
    })
    self.motorBinding = RoactFlipper.getBinding(self.motor)

    self:setState({
        Rating = self.props.Rating
    })
end

function Ranking:didUpdate(_, prevState)
    if self.state.subdivisionChanged ~= prevState.subdivisionChanged or self.state.divisionChanged ~= prevState.divisionChanged then
        self.motor:setGoal({
            rankUp = Flipper.Spring.new(if self.state.subdivisionChanged or self.state.divisionChanged then 1 else 0, {
                frequency = 2,
                dampingRatio = 1
            })
        })
    end
end

function Ranking:render()
    local rankChangedText
    local rankChangedColor

    if self.state.divisionChanged then
        rankChangedText = if self.state.up then "PROMOTION" else "DEMOTION"
        rankChangedColor = if self.state.up then Color3.fromRGB(15, 219, 25) else Color3.fromRGB(228, 12, 12)
    elseif self.state.subdivisionChanged then
        rankChangedText = if self.state.up then "DIVISION UP" else "DIVISION DOWN"
        rankChangedColor = if self.state.up then Color3.fromRGB(15, 219, 25) else Color3.fromRGB(228, 12, 12)
    else
        rankChangedText = "CURRENT TIER"
        rankChangedColor = Color3.fromRGB(218, 218, 218)
    end

    return e(RoundedFrame, {
        Position = self.props.Position,
        Size = self.props.Size,
        AnchorPoint = self.props.AnchorPoint,
        BackgroundTransparency = 1,
    }, {
        Tier = e(Tier, {
            tier = self.state.tier,
            division = self.state.division,
            imageLabelProps = {
                Size = UDim2.fromScale(0.2, 1),
                Position = UDim2.fromScale(0.72, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                -- ImageTransparency = self.motorBinding:map(function(v)
                --     return 1 - v
                -- end)
            }
        }, {
            Tier = e(RoundedTextLabel, {
                Size = UDim2.fromScale(2, 0.35),
                Position = UDim2.fromScale(-0.2, 0.55),
                AnchorPoint = Vector2.new(1, 1),
                BackgroundTransparency = 1,
                Text = self.state.tier:upper() .. if self.state.division then " " .. string.rep("I", self.state.division) else "",
                TextScaled = true,
                TextColor3 = Color3.fromRGB(218, 218, 218),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Bottom,
                Font = Enum.Font.GothamBold
                -- TextTransparency = if self.state.divisionUp then 0 else 1
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MaxTextSize = 25
                })
            }),
            Subdivision = if self.state.subdivision then e(RoundedTextLabel, {
                Size = UDim2.fromScale(2, 0.2),
                Position = UDim2.fromScale(-0.2, 0.53),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = "DIVISION " .. if self.state.subdivision == 4 then "IV" else string.rep("I", self.state.subdivision),
                TextScaled = true,
                TextColor3 = Color3.fromRGB(218, 218, 218),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                Font = Enum.Font.GothamMedium
            }) else nil,
            RankUp = e(RoundedTextLabel, {
                Size = UDim2.fromScale(2, 0.17),
                Position = UDim2.fromScale(-0.2, 0.31),
                AnchorPoint = Vector2.new(1, 1),
                BackgroundTransparency = 1,
                Text = rankChangedText,
                TextScaled = true,
                TextColor3 = rankChangedColor,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                Font = Enum.Font.Gotham
            })
        })
    })
end

return Ranking
