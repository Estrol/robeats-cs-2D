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

local function findPlayer(player)
    return function(p)
        return p.player.UserId == player.UserId
    end
end

function SpectatingService:KnitInit()
    game.Players.PlayerRemoving:Connect(function(player)
        self:RemovePlayer(player)
    end)

    self.Client.Spectate:Connect(function(player, targetUserId)
        currentlySpectating[tostring(player.UserId)] = game.Players:GetPlayerByUserId(targetUserId)
    end)

    self.Client.Unspectate:Connect(function(player)
        self:RemovePlayer(player)
    end)
end

function SpectatingService:KnitStart()
    StateService = Knit.GetService("StateService")

    local store = StateService.Store

    self.Client.GameStarted:Connect(function(player, songHash, songRate)
        if not findWhere(store:getState().spectating.players, findPlayer(player)) then
            store:dispatch({
                type = "addPlayerToSpectate",
                player = player,
                songHash = songHash,
                songRate = songRate,
            })
        end
    end)

    self.Client.GameEnded:Connect(function(player)
        self:RemovePlayer(player)
    end)
end

function SpectatingService:RemovePlayer(player)
    currentlySpectating[tostring(player.UserId)] = nil

    local store = StateService.Store

    if findWhere(store:getState().spectating.players, findPlayer(player)) then
        store:dispatch({
            type = "removePlayerFromSpectate",
            player = player,
        })
    end
end

function SpectatingService.Client:DisemminateHits(player, hits)
    local toDissemminate = {}

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and currentlySpectating[tostring(otherPlayer.UserId)] == player then
            table.insert(toDissemminate, otherPlayer)
        end
    end

    if #toDissemminate > 0 then
        self.HitsSent:FireFor(toDissemminate, hits)
    end
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