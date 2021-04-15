local Remotes = require(game.ReplicatedStorage.Remotes)

local ScoreAPI = require(game.ServerScriptService.API.ScoreAPI)

local SubmitScore = Remotes.Server:Create("SubmitScore")
SubmitScore:Connect(ScoreAPI.submitScore)
