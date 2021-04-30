local Knit = require(game.ReplicatedStorage.Knit)

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

    baseUrl = (RunService:IsStudio() or (game.ServerScriptService:FindFirstChild("UseReleaseAPI") and game.ServerScriptService.UseReleaseAPI.Value)) and game:GetService("ServerScriptService").URLs.Release.Value or game:GetService("ServerScriptService").URLs.Dev.Value
end

function ScoreService:KnitStart()
    local SecretService = Knit.GetService("SecretService")

    Scores = Server.Objects.class("Plays")
    Server:setAppId(SecretService:GetSecret("ParseAppId")):setBaseUrl(baseUrl)
end

function ScoreService.Client:SubmitScore(player, songMD5Hash, rating, score, marvelouses, perfects, greats, goods, bads, misses, accuracy, mean, rate)
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
