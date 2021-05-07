local Knit = require(game.ReplicatedStorage.Knit)

local DataStoreService = game:GetService("DataStoreService")
local LocalizationService = game:GetService("LocalizationService")

local GraphDataStore = DataStoreService:GetDataStore("GraphDataStore")

local DebugOut = require(game.ReplicatedStorage.Shared.DebugOut)

local ParseServer = require(game.ReplicatedStorage.Packages.ParseServer)
local Server
local Scores
local Global

local baseUrl

local RunService = game:GetService("RunService")

local ScoreService = Knit.CreateService({
    Name = "ScoreService",
    Client = {}
})

function ScoreService:KnitInit()
    Server = ParseServer.new()

    if RunService:IsStudio() then
        baseUrl = game.ServerScriptService:GetAttribute("UseReleaseAPI") and game:GetService("ServerScriptService").URLs.Release.Value or game:GetService("ServerScriptService").URLs.Dev.Value
    else
        baseUrl = game:GetService("ServerScriptService").URLs.Release.Value
    end

    local SecretService = Knit.GetService("SecretService")
    
    Scores = Server.Objects.class("Plays")
    Global = Server.Objects.class("Global")
    Server:setAppId(SecretService:GetSecret("ParseAppId")):setBaseUrl(baseUrl)

    DebugOut:puts("Base API URL: %s", baseUrl)
end

function ScoreService:_GetGraphKey(userId, songMD5Hash)
    return string.format("Graph(%s%s)", userId, songMD5Hash)
end

function ScoreService:GetPlayerScores(userId, limit)
    local succeeded, documents = Scores
        :query()
        :where({
            UserId = userId
        })
        :order("-Rating")
        :limit(limit)
        :execute()
        :await()

    if succeeded then
        return documents, succeeded
    else
        warn(documents)
        return {}, succeeded
    end
end

function ScoreService:CalculateRating(userId)
    local scores = self:GetPlayerScores(userId)

    local rating = 0;
    local maxNumOfScores = math.min(#scores, 25);

    for i = 1, maxNumOfScores do
        if i > 10 then
            rating = rating + scores[i].Rating * 1.5
        else
            rating = rating + scores[i].Rating;
        end
    end

    return math.floor((100 * rating) / 30) / 100
end

function ScoreService:CalculateAverageAccuracy(userId)
    local scores = self:GetPlayerScores(userId)

    local accuracy = 0

    for _, score in ipairs(scores) do
        accuracy += score.Accuracy
    end

    return accuracy / #scores
end

function ScoreService:RefreshProfile(player)
    local succeeded, slots = Global
            :query()
            :where({
                UserId = player.UserId
            })
            :execute()
            :await()

    if succeeded then
        local slot = slots[1]

        if slot then
            Global
                :update(slot.objectId, {
                    TotalMapsPlayed = {
                        __op = "Increment",
                        amount = 1
                    },
                    Rating = ScoreService:CalculateRating(player.UserId),
                    Accuracy = ScoreService:CalculateAverageAccuracy(player.UserId),
                    PlayerName = player.DisplayName,
                    UserId = player.UserId
                })
                :andThen(function(document)
                    DebugOut:puts("Global leaderboard slot successfully updated!")
                end)
            else
                Global
                    :create({
                        TotalMapsPlayed = 1,
                        Rating = ScoreService:CalculateRating(player.UserId),
                        Accuracy = ScoreService:CalculateAverageAccuracy(player.UserId),
                        PlayerName = player.DisplayName,
                        CountryRegion = LocalizationService:GetCountryRegionForPlayerAsync(player),
                        UserId = player.UserId
                    })
                    :andThen(function(document)
                        DebugOut:puts("Global leaderboard slot successfully created!")
                    end)
        end
    end
end

function ScoreService.Client:SubmitScore(player, songMD5Hash, rating, score, marvelouses, perfects, greats, goods, bads, misses, accuracy, maxChain, mean, rate)
    local succeeded, documents = Scores
        :query()
        :where({
            SongMD5Hash = songMD5Hash,
            UserId = player.UserId
        })
        :execute()
        :await()

    if succeeded then
        local oldScore = documents[1]

        if not oldScore then
            succeeded = Scores:create({
                UserId = player.UserId,
                PlayerName = player.DisplayName,
                Rating = rating,
                Score = score,
                Marvelouses = marvelouses,
                Perfects = perfects,
                Greats = greats,
                Goods = goods,
                Bads = bads,
                Misses = misses,
                Mean = mean,
                Accuracy = accuracy,
                Rate = rate,
                MaxChain = maxChain,
                SongMD5Hash = songMD5Hash
            })
            :await()
            ScoreService:RefreshProfile(player)
            return succeeded
        end

        local overwrite = false

        if oldScore.Rating == 0 and rating == 0 then
            overwrite = score > oldScore.Score
        else
            overwrite = rating > oldScore.Rating
        end

        if overwrite then
            Scores:update(oldScore.objectId, {
                PlayerName = player.DisplayName,
                Rating = rating,
                Score = score,
                Marvelouses = marvelouses,
                Perfects = perfects,
                Greats = greats,
                Goods = goods,
                Bads = bads,
                Misses = misses,
                Mean = mean,
                Accuracy = accuracy,
                Rate = rate,
            }):await()
        end

        ScoreService:RefreshProfile(player)
    else
        return false
    end
    
    return succeeded
end

function ScoreService.Client:SubmitGraph(player, songMD5Hash, graph)
    local key = ScoreService:_GetGraphKey(player.UserId, songMD5Hash)

    GraphDataStore:SetAsync(key, graph)
end

function ScoreService.Client:GetGraph(_, userId, songMD5Hash)
    local key = ScoreService:_GetGraphKey(userId, songMD5Hash)
    
    return GraphDataStore:GetAsync(key)
end

function ScoreService.Client:GetScores(_, songMD5Hash)
    local succeeded, documents = Scores
        :query()
        :where({
            SongMD5Hash = songMD5Hash
        })
        :order("-Rating")
        :execute()
        :await()

    if succeeded then
        return documents, succeeded
    else
        warn(documents)
        return {}, succeeded
    end
end

function ScoreService.Client:GetRank(player)
    local succeeded, ranks = Global
        :query({})
        :order("-Rating")
        :execute()
        :await()

    if not succeeded then
        warn(ranks)
        return
    end
    
    for rank = 1, #ranks do
        local profile = ranks[rank]

        if profile.UserId == player.UserId then
            return rank
        end
    end

    return -1
end

function ScoreService.Client:GetProfile(player)
    local succeeded, profiles = Global
        :query()
        :where({
            UserId = player.UserId
        })
        :order("-Rating")
        :execute()
        :await()

    if not succeeded then
        warn(profiles)
        return
    end

    local profile = profiles[1]

    if profile then
        return profile
    end

    return {}
end

function ScoreService.Client:GetGlobalLeaderboard()
    local succeeded, ranks = Global
        :query({})
        :order("-Rating")
        :limit(50)
        :execute()
        :await()

    if succeeded then
        return ranks
    end

    warn(ranks)
    return {}
end

function ScoreService.Client:GetPlayerScores(player, userId)
    return ScoreService:GetPlayerScores(userId or player.UserId)
end

return ScoreService
