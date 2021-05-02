local Knit = require(game.ReplicatedStorage.Knit)

local DataStoreService = game:GetService("DataStoreService")
local GraphDataStore = DataStoreService:GetDataStore("GraphDataStore")

local DebugOut = require(game.ReplicatedStorage.Shared.DebugOut)

local ParseServer = require(game.ReplicatedStorage.Packages.ParseServer)
local Server
local Scores

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

    DebugOut:puts("Base API URL: %s", baseUrl)
end

function ScoreService:KnitStart()
    local SecretService = Knit.GetService("SecretService")

    Scores = Server.Objects.class("Plays")
    Server:setAppId(SecretService:GetSecret("ParseAppId")):setBaseUrl(baseUrl)
end

function ScoreService:_GetGraphKey(userId, songMD5Hash)
    return string.format("Graph(%s%s)", userId, songMD5Hash)
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
            })
            :andThen(function(document)
                print(document)
            end)
        end
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

return ScoreService
