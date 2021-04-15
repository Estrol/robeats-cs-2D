local DebugOut = require(game.ReplicatedStorage.Shared.DebugOut)

local ScoreAPI = {}

function ScoreAPI.submitScore(player)
    DebugOut:puts("%s just submitted a score", player.Name)
end

return ScoreAPI
