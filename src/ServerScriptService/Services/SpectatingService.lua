local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Llama = require(game:GetService("ReplicatedStorage").Packages.Llama)

local findWhere = Llama.List.findWhere

local SpectatingService = Knit.CreateService {
    Name = "SpectatingService",
    Client = {
        Spectate = Knit.CreateSignal(),
        Unspectate = Knit.CreateSignal(),
        HitsSent = Knit.CreateSignal(),
        GameStarted = Knit.CreateSignal(),
        GameEnded = Knit.CreateSignal(),
    }
}

local StateService

local currentlySpectating = {}

function SpectatingService:KnitInit()
    game.Players.PlayerRemoving:Connect(function(player)
        currentlySpectating[tostring(player.UserId)] = nil
    end)

    self.Client.Spectate:Connect(function(player, targetUserId)
        currentlySpectating[tostring(player.UserId)] = game.Players:GetPlayerByUserId(targetUserId)
    end)

    self.Client.Unspectate:Connect(function(player)
        currentlySpectating[tostring(player.UserId)] = nil
    end)
end

function SpectatingService:KnitStart()
    StateService = Knit.GetService("StateService")

    local store = StateService.Store

    local function findPlayer(player)
        return function(p)
            return p.player.UserId == player.UserId
        end
    end

    self.Client.GameStarted:Connect(function(player, songKey, songRate)
        if not findWhere(store:getState().spectating.players, findPlayer(player)) then
            store:dispatch({
                type = "addPlayerToSpectate",
                player = player,
                songKey = songKey,
                songRate = songRate,
            })
        end
    end)

    self.Client.GameEnded:Connect(function(player)
        if findWhere(store:getState().spectating.players, findPlayer(player)) then
            store:dispatch({
                type = "removePlayerFromSpectate",
                player = player,
            })
        end
    end)
end

function SpectatingService.Client:DisemminateHits(player, hits)
    local toDissemminate = {}

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and currentlySpectating[tostring(otherPlayer.UserId)] then
            table.insert(toDissemminate, otherPlayer)
        end
    end

    self.HitsSent:FireFor(toDissemminate, hits)
end

function SpectatingService.Client:GetSpectators(player)
    local spectating = {}

    for spectator, ongoingPlayer in pairs(currentlySpectating) do
        if ongoingPlayer.UserId == player.UserId then
            table.insert(spectating, game.Players:GetPlayerByUserId(tonumber(spectator)))
        end
    end

    return spectating
end

return SpectatingService