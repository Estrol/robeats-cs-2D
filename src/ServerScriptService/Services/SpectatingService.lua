local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local SpectatingService = Knit.CreateService {
    Name = "SpectatingService",
    Client = {
        Spectate = Knit.CreateSignal(),
        Unspectate = Knit.CreateSignal(),
        HitsSent = Knit.CreateSignal(),
    }
}

local StateService

local currentlySpectating = {}

function SpectatingService:KnitInit()
    game.Players.PlayerRemoving:Connect(function(player)
        currentlySpectating[tostring(player.UserId)] = nil
    end)

    self.Client.Spectate:Connect(function(player)
        currentlySpectating[tostring(player.UserId)] = player
    end)

    self.Client.Unspectate:Connect(function(player)
        currentlySpectating[tostring(player.UserId)] = nil
    end)
end

function SpectatingService:KnitStart()
    StateService = Knit.GetService("StateService")
end

function SpectatingService.Client:DisemminateHits(player, hits)
    print(hits)

    local toDissemminate = {}

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and currentlySpectating[tostring(otherPlayer.UserId)] then
            table.insert(toDissemminate, otherPlayer)
        end
    end

    self.HitsSent:FireFor(toDissemminate, hits)
end

function SpectatingService.Client:GetSpectating(player)
    local spectating = {}

    for spectator, ongoingPlayer in pairs(currentlySpectating) do
        if ongoingPlayer.UserId == player.UserId then
            spectating[spectator] = game.Players:FindFirstChild(tonumber(spectator))
        end
    end

    return spectating
end

return SpectatingService