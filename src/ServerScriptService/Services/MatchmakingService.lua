local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Llama = require(game.ReplicatedStorage.Packages.Llama)

local MatchmakingService = Knit.CreateService {
    Name = "MatchmakingService";
    Client = {};
}

MatchmakingService.WIN = "win"
MatchmakingService.LOSS = "loss"

local RateLimitService
local AuthService
local ScoreService

local Raxios

local url = require(game.ServerScriptService.URLs)

local matches = {}

function MatchmakingService:KnitStart()
    AuthService = Knit.GetService("AuthService")
    RateLimitService = Knit.GetService("RateLimitService")
    ScoreService = Knit.GetService("ScoreService")

    Raxios = require(game.ReplicatedStorage.Packages.Raxios)
end

function MatchmakingService.Client:ReportMatch(player, data)
    if RateLimitService:CanProcessRequestWithRateLimit("ReportMatch", player, 3) then
        if not matches[player] then
            matches[player] = data
        end
    end
end

function MatchmakingService:RemoveMatch(player)
    matches[player] = nil
end

function MatchmakingService:GetMatch(player)
    return matches[player]
end

function MatchmakingService:HandleMatchResult(player, result)
    if RateLimitService:CanProcessRequestWithRateLimit("ReportMatch", player, 1) then
        local match = matches[player]

        if match then
            local result = Raxios.post(url "/matchmaking/result", {
                query = {
                    userid = player.UserId,
                    result = result,
                    hash = match.SongMD5Hash,
                    rate = match.Rate,
                    auth = AuthService.APIKey
                }
            }):json()

            self:RemoveMatch(player)

            return result
        else
            warn("No match found!")
        end
    end
end

function MatchmakingService.Client:GetMatch(player, mmr)
    if RateLimitService:CanProcessRequestWithRateLimit("GetMatch", player, 3) then
        return Raxios.get(url "/maps/difficulty", {
            query = { closest = mmr },
            auth = AuthService.APIKey
        }):json()
    end
end

function MatchmakingService.Client:ReportLeftEarly(player)
    local result = MatchmakingService:HandleMatchResult(player, MatchmakingService.LOSS)

    if result and Llama.Dictionary.count(result) > 0 then
        ScoreService:PopulateUserProfile(player, true)
    end

    return result
end

return MatchmakingService