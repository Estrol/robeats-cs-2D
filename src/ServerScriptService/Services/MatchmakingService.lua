local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local MatchmakingService = Knit.CreateService {
    Name = "MatchmakingService";
    Client = {};
}

local RateLimitService
local AuthService

local Raxios

local url = require(game.ServerScriptService.URLs)

local matches = {}

function MatchmakingService:KnitStart()
    AuthService = Knit.GetService("AuthService")
    RateLimitService = Knit.GetService("RateLimitService")

    Raxios = require(game.ReplicatedStorage.Packages.Raxios)
end

function MatchmakingService.Client:ReportMatch(player, data)
    if RateLimitService:CanProcessRequestWithRateLimit("ReportMatch", player, 3) then
        if not matches[player] then
            matches[player] = data
        end
    end
end

function MatchmakingService.Client:HandleMatchResult(player, result)
    if RateLimitService:CanProcessRequestWithRateLimit("ReportMatch", player, 1) then
        local match = matches[player]

        if match then
            
        end
    end
end

function MatchmakingService.Client:GetMatch(player)
    if RateLimitService:CanProcessRequestWithRateLimit("GetMatch", player, 3) then
        return Raxios.get(url "/maps/difficulty", {
            query = { closest = 1500 },
            auth = AuthService.APIKey
        }):json()
    end
end

return MatchmakingService