local LocalizationService = game:GetService("LocalizationService")

local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Llama = require(game.ReplicatedStorage.Packages.Llama)

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local DEFAULT_MMR = 1500

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

    game.Players.PlayerRemoving:Connect(function(player)
        if matches[player] then
            self:HandleMatchResult(player, MatchmakingService.LOSS)
        end
    end)
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
            local country

            pcall(function()
                country = LocalizationService:GetCountryRegionForPlayerAsync(player)
            end)

            local result = Raxios.post(url "/matchmaking/result", {
                query = {
                    userid = player.UserId,
                    result = result,
                    hash = match.SongMD5Hash,
                    rate = match.Rate,
                    countrycode = country,
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
    mmr = if mmr then mmr else DEFAULT_MMR

    if RateLimitService:CanProcessRequestWithRateLimit("GetMatch", player, 3) then
        local matches = Raxios.get(url "/maps/difficulty", {
            query = { closest = mmr },
            auth = AuthService.APIKey
        }):json()

        local ideal
        local matchNumber = 0

        for _, match in matches do
            local songKey = SongDatabase:get_key_for_hash(match.SongMD5Hash)

            if songKey ~= SongDatabase:invalid_songkey() then
                local songLength = SongDatabase:get_song_length_for_key(songKey, match.Rate / 100)
                
                local IDEAL_SONG_LENGTH = 140000
                
                -- cut out any songs too short or too long
                if songLength <= 60000 or songLength >= 300000 then
                    continue
                end

                matchNumber += 1

                local songLengthScore = IDEAL_SONG_LENGTH - math.abs(songLength - IDEAL_SONG_LENGTH)
                local closeToBaseRateScore = 100 - math.abs(100 - match.Rate) -- out of 100

                local score = (songLengthScore / IDEAL_SONG_LENGTH * 0.6) + (closeToBaseRateScore / 100 * 0.4)

                if matchNumber == 1 or score > ideal.score then
                    ideal = { match = match, score = score }
                end
            end
        end

        return ideal and ideal.match
    end
end

function MatchmakingService.Client:GetMapMMR(player, hash)
    if RateLimitService:CanProcessRequestWithRateLimit("GetMapMMR", player, 3) then
        local mmr = Raxios.get(url "/maps", {
            query = { hash = hash, auth = AuthService.APIKey }
        }):json()

        return mmr
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