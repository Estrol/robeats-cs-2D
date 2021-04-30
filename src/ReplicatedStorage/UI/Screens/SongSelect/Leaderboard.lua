local Roact = require(game.ReplicatedStorage.Packages.Roact)

local RunService = game:GetService("RunService")

local RoundedTextLabel =  require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedAutoScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedAutoScrollingFrame)
local LoadingWheel = require(game.ReplicatedStorage.UI.Components.Base.LoadingWheel)

local LeaderboardSlot = require(game.ReplicatedStorage.UI.Screens.SongSelect.LeaderboardSlot)

local Leaderboard = Roact.Component:extend("LeaderboardDisplay")

Leaderboard.defaultProps = {
    Leaderboard = {},
    Position = UDim2.fromScale(0, 0),
    Size = UDim2.fromScale(1, 1)
}

function Leaderboard:init()
    if RunService:IsRunning() then
        self.knit = require(game.ReplicatedStorage.Knit)
    end

    self:setState({
        loading = false,
        scores = {} -- List of scores to display. Can be fetched from some external resource. This is the format it follows:
        -- {
        --     UserId = 526993347,
        --     PlayerName = "kisperal",
        --     Marvelouses = 6,
        --     Perfects = 5,
        --     Greats = 4,
        --     Goods = 3,
        --     Bads = 2,
        --     Misses = 1,
        --     Time = 1596444113,
        --     Accuracy = 98.98,
        --     Place = 1,
        --     Score = 0
        -- }
        -- WHEN YOU ARE TESTING THE DATASET PLEASE DO NOT COMMIT THE DATA!!!
        -- I am actually not sure how to do the actual fetching with Knit. Doing something story-based would be coolio
    })
end

function Leaderboard:performFetch()
    if self.knit then
        self:setState({
            loading = true
        })
        self.knit.GetService("ScoreService"):GetScoresPromise(self.props.SongKey):andThen(function(scores)
            self:setState({
                scores = scores,
                loading = false
            })
        end)
    end
end

function Leaderboard:didMount()
    self:performFetch()
end

function Leaderboard:didUpdate(lastProps)
    if lastProps.SongKey ~= self.props.SongKey then
        self:performFetch()
    end
end

function Leaderboard:render()
    if self.state.loading then
        return Roact.createElement(RoundedFrame, {
            Active = true,
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            BackgroundTransparency = 0,
            BorderColor3 = Color3.fromRGB(25, 25, 25),
            BorderSizePixel = 0,
            Position = self.props.Position,
            AnchorPoint = self.props.AnchorPoint,
            Size = self.props.Size
        }, {
            LoadingWheel = Roact.createElement(LoadingWheel, {
                RotationSpeed = 0.45,
                Size = UDim2.fromScale(0.13, 0.13),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5)
            })
        })
    elseif #self.state.scores == 0 then
        return Roact.createElement(RoundedFrame, {
            Active = true,
            BackgroundColor3 = Color3.fromRGB(25, 25, 25),
            BackgroundTransparency = 0,
            BorderColor3 = Color3.fromRGB(25, 25, 25),
            BorderSizePixel = 0,
            Position = self.props.Position,
            AnchorPoint = self.props.AnchorPoint,
            Size = self.props.Size
        }, {
            NoScoresMessage = Roact.createElement(RoundedTextLabel, {
                Size = UDim2.fromScale(0.95, 0.3),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Text = "🏆 There are no scores to display! How about setting one?",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 13,
                BackgroundTransparency = 1
            })
        })
    end

    local children = {}
    
    for i, v in pairs(self.state.scores) do
        children[i] = Roact.createElement(LeaderboardSlot, v)
    end

    return Roact.createElement(RoundedAutoScrollingFrame, {
        Active = true,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BackgroundTransparency = 0,
        BorderColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Position = self.props.Position,
        AnchorPoint = self.props.AnchorPoint,
        Size = self.props.Size,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left,
        UIListLayoutProps = {
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 4),
        }
    }, {
        Children = Roact.createFragment(children)
    });
end

return Leaderboard
