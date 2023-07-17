local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement
local f = Roact.createFragment
local Llama = require(game.ReplicatedStorage.Packages.Llama)

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)
local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local StarterGUI = game:GetService("StarterGui")

local LeaderboardSlot = require(game.ReplicatedStorage.UI.Screens.Gameplay.LeaderboardSlot)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)

local Leaderboard = Roact.Component:extend("Leaderboard")

Leaderboard.defaultProps = {
    SongKey = 1,
    LocalRating = 0,
    LocalAccuracy = 0,
    UserId = game.Players.LocalPlayer.UserId,
    PlayerName = game.Players.LocalPlayer.Name,
}

function Leaderboard:init()
    self:setState({
        scores = {},
        visible = true,
    })

    local ScoreService = Knit.GetService("ScoreService")

    ScoreService:GetScores(SongDatabase:get_hash_for_key(self.props.SongKey), 8):andThen(function(scores)
        self:setState({
            scores = scores
        })
    end)

    StarterGUI:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)


    SPUtil:bind_to_key(self.props.settings.ToggleLeaderboardKeybind, function()
        self:setState({visible = not self.state.visible})
    end)

end

function Leaderboard:render()
    local children = {}

    local scores = Llama.Dictionary.copy(self.state.scores)

    local localSlot = string.format("LocalPlayer(%d)", game.Players.LocalPlayer.UserId)

    table.insert(scores, {
        PlayerName = self.props.PlayerName,
        UserId = self.props.UserId,
        Rating = {
            Overall = self.props.LocalRating
        },
        Accuracy = self.props.LocalAccuracy,
        _id = localSlot
    })

    table.sort(scores, function(a, b)
        return a.Rating.Overall > b.Rating.Overall
    end)

    for itr_score_index, itr_score in ipairs(scores) do
        local itr_score_element = e(LeaderboardSlot, {
            PlayerName = itr_score.PlayerName,
            UserId = itr_score.UserId,
            Rating = itr_score.Rating,
            Accuracy = itr_score.Accuracy,
            Place = itr_score_index,
            IsLocalProfile = itr_score._id == localSlot
        })

        children[itr_score._id] = itr_score_element
    end

    return e(RoundedFrame, {
        Position = self.props.Position,
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromScale(0.175, 0.5),
        BackgroundTransparency = 1,
        Visible = self.state.visible,
    }, children)
end

return RoactRodux.connect(function(state, props)
    return {
        settings = Llama.Dictionary.join(state.options.persistent, state.options.transient)
    }
end)(Leaderboard)