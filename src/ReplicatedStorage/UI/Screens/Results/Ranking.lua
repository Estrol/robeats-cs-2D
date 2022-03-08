local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)

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
        subdivisionUp = if prevTier then tier.subdivision ~= prevTier.subdivision else false,
        divisionUp = if prevTier then tier.division ~= prevTier.division else false,
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
    if self.state.subdivisionUp ~= prevState.subdivisionUp then
        self.motor:setGoal({
            rankUp = Flipper.Spring.new(if self.state.subdivisionUp then 1 else 0, {
                frequency = 2,
                dampingRatio = 1
            })
        })
    end
end

function Ranking:render()
    return e(Tier, {
        tier = self.state.tier,
        division = self.state.division,
        imageLabelProps = {
            Size = self.props.Size,
            Position = self.props.Position,
            AnchorPoint = self.props.AnchorPoint,
            BackgroundTransparency = 1,
            -- ImageTransparency = self.motorBinding:map(function(v)
            --     return 1 - v
            -- end)
        }
    }, {
        Tier = e(RoundedTextLabel, {
            Size = UDim2.fromScale(2, 0.35),
            Position = UDim2.fromScale(1.2, 0.55),
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            Text = self.state.tier:upper() .. if self.state.division then " " .. string.rep("I", self.state.division) else "",
            TextScaled = true,
            TextColor3 = Color3.fromRGB(218, 218, 218),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Bottom,
            Font = Enum.Font.SciFi
            -- TextTransparency = if self.state.divisionUp then 0 else 1
        }),
        Subdivision = if self.state.subdivision then e(RoundedTextLabel, {
            Size = UDim2.fromScale(2, 0.2),
            Position = UDim2.fromScale(1.2, 0.53),
            AnchorPoint = Vector2.new(0, 0),
            BackgroundTransparency = 1,
            Text = "DIVISION " .. if self.state.subdivision == 4 then "IV" else string.rep("I", self.state.subdivision),
            TextScaled = true,
            TextColor3 = Color3.fromRGB(218, 218, 218),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            Font = Enum.Font.SciFi
            -- TextTransparency = if self.state.subdivisionUp then 0 else 1
        }) else nil,
        RankUp = e(RoundedTextLabel, {
            Size = UDim2.fromScale(1, 0.4),
            Position = self.motorBinding:map(function(a)
                return UDim2.fromScale(1.2, 0.01) + UDim2.fromScale((1 - a.rankUp) * 0.2, 0.01)
            end),
            AnchorPoint = Vector2.new(0, 0),
            BackgroundTransparency = 1,
            Text = if self.state.divisionUp then "PROMOTION" elseif self.state.subdivisionUp then "DIVISION UP" else "",
            TextScaled = true,
            TextColor3 = Color3.fromRGB(15, 219, 25),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            Font = Enum.Font.SciFi,
            TextTransparency = self.motorBinding:map(function(a)
                return 1 - a.rankUp
            end)
        })
    })
end

return Ranking
