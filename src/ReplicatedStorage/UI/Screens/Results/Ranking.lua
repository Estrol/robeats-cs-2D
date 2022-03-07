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
    local prevTier = if lastState.Rating then Tiers:GetTierFromRating(lastState.rating) else nil
    local tier = Tiers:GetTierFromRating(nextProps.Rating)

    return {
        rating = nextProps.Rating,
        tier = tier.name,
        division = tier.division,
        subdivision = tier.subdivision,
        subdivisionUp = if prevTier then tier.subdivision ~= prevTier.subdivision else false,
        divisionUp = if prevTier then tier.division ~= prevTier.division else false,
    }
end

function Ranking:init()
    self.rankUpMotor = Flipper.SingleMotor.new(0)
    self.rankUpMotorBinding = RoactFlipper.getBinding(self.rankUpMotor)

    self:setState({
        Rating = self.props.Rating
    })
end

function Ranking:didUpdate(_, prevState)
    if self.state.subdivisionUp ~= prevState.subdivisionUp then
        self.rankUpMotor:setGoal(Flipper.Spring.new(if self.state.subdivisionUp then 1 else 0, {
            frequency = 2,
            dampingRatio = 1
        }))
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
            -- ImageTransparency = self.rankUpMotorBinding:map(function(v)
            --     return 1 - v
            -- end)
        }
    }, {
        Tier = e(RoundedTextLabel, {
            Size = UDim2.fromScale(2, 0.35),
            Position = UDim2.fromScale(1.2, 0.55),
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            Text = self.state.tier:upper() .. " " .. string.rep("I", self.state.division),
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
            Position = self.rankUpMotorBinding:map(function(a)
                return UDim2.fromScale(1.2, -0.12) + UDim2.fromScale((1 - a) * 0.2, 0)
            end),
            AnchorPoint = Vector2.new(0, 0),
            BackgroundTransparency = 1,
            Text = if self.state.divisionUp then "PROMOTION" elseif self.state.subdivisionUp then "DIVISION UP" else "",
            TextScaled = true,
            TextColor3 = Color3.fromRGB(15, 219, 25),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            Font = Enum.Font.SciFi,
            TextTransparency = self.rankUpMotorBinding:map(function(a)
                return 1 - a
            end)
        })
    })
end

return Ranking
