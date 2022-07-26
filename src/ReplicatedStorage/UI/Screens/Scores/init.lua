local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Llama = require(game.ReplicatedStorage.Packages.Llama)
local e = Roact.createElement

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local RunService = game:GetService("RunService")

local Score = require(script.Score)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedAutoScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedAutoScrollingFrame)

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local Scores = Roact.Component:extend("Scores")

function Scores:init()
    self:setState({
        scores = {}
    })

    self.props.scoreService:GetPlayerScores(self.props.location.state.userId):andThen(function(scores)
        self:setState({
            scores = scores
        })
    end)
end

function Scores:render()
    local scores = {}

    for place, score in ipairs(self.state.scores) do
        local props = Llama.Dictionary.join(score, {
            Place = place,
            OnClick = function()
                local _, hits = self.props.scoreService:GetGraph(score.UserId, score.SongMD5Hash)
                    :await()

                self.props.history:push("/results", Llama.Dictionary.join(score, {
                    SongKey = SongDatabase:get_key_for_hash(score.SongMD5Hash),
                    TimePlayed = if score._updated_at then DateTime.fromIsoDate(score._updated_at).UnixTimestamp else nil,
                    Hits = hits,
                    Viewing = true
                }))
            end
        })

        local scoreSlot = e(Score, props)

        table.insert(scores, scoreSlot)
    end

    return e(RoundedFrame, {

    }, {
        ScoreContainer = e(RoundedAutoScrollingFrame, {
            Size = UDim2.fromScale(0.75, 0.8),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            ScrollBarThickness = 5,
            UIListLayoutProps = {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 3)
            }
        }, scores),
        BackButton = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.05, 0.05),
            HoldSize = UDim2.fromScale(0.06, 0.06),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.124, 0.95),
            BackgroundColor3 = Color3.fromRGB(212, 23, 23),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Back",
            TextSize = 12,
            OnClick = function()
                self.props.history:goBack()
            end
        })
    })
end

local Injected = withInjection(Scores, {
    scoreService = "ScoreService"
})

return Injected