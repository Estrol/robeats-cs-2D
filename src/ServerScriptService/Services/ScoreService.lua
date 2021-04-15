local Knit = require(game.ReplicatedStorage.Knit)

local ScoreService = Knit.CreateService({
    Name = "ScoreService",
    Client = {}
})

function ScoreService.Client:SubmitScore()
    print("Hello from Score Service RemoteSignal")
end

return ScoreService
