local Knit = require(game.ReplicatedStorage.Packages.Knit)

local DataStoreService = require(game.ReplicatedStorage.Packages.DataStoreService)
local LocalizationService = game:GetService("LocalizationService")

local GraphDataStore = DataStoreService:GetDataStore("GraphDataStore")

local DebugOut = require(game.ReplicatedStorage.Shared.DebugOut)
local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local Tiers = require(game.ReplicatedStorage.Tiers)

local RunService

local PermissionsService
local ModerationService
local RateLimitService
local AuthService
local StateService

local Llama
local Raxios
local Hook
local FormatHelper

local ScoreService = Knit.CreateService({
    Name = "ScoreService",
    Client = {}
})

local url = require(game.ServerScriptService.URLs)

function ScoreService:KnitInit()
    RunService = game:GetService("RunService")

    PermissionsService = Knit.GetService("PermissionsService")
    ModerationService = Knit.GetService("ModerationService")
    RateLimitService = Knit.GetService("RateLimitService")
    AuthService = Knit.GetService("AuthService")
    StateService = Knit.GetService("StateService")

    Llama = require(game.ReplicatedStorage.Packages.Llama)    
    Raxios = require(game.ReplicatedStorage.Packages.Raxios)
end

function ScoreService:PopulateUserProfile(player, override)
    local state = StateService.Store:getState()

    if state.profiles[tostring(player.UserId)] and not override then
        return
    end

    local profile = self:GetProfile(player)

    if Llama.Dictionary.count(profile) > 0 and not profile.error then
        if typeof(profile.Rating) == "number" then
            profile.Rating = { Overall = profile.Rating }
        end

        StateService.Store:dispatch({ type = "addProfile", player = player, profile = profile })

        local leaderstats = player:FindFirstChild("leaderstats")

        local rating
        local rank
        local tier

        if not leaderstats then
            leaderstats = Instance.new("Folder")
            leaderstats.Name = "leaderstats"

            rating = Instance.new("NumberValue")
            rating.Name = "Rating"

            rank = Instance.new("StringValue")
            rank.Name = "Rank"

            tier = Instance.new("StringValue")
            tier.Name = "Tier"

            rating.Parent = leaderstats
            rank.Parent = leaderstats
            tier.Parent = leaderstats

            leaderstats.Parent = player
        end

        rating.Value = profile.Rating.Overall
        rank.Value = "#" .. profile.Rank

        local tierInfo = Tiers:GetTierFromRating(profile.Rating.Overall)

        if tierInfo then
            tier.Value = string.sub(tierInfo.name, 1, 1)

            if tierInfo.division then
                tier.Value = tier.Value .. tierInfo.division
            end
        end
    end
end

function ScoreService:KnitStart()
    local function onPlayerAdded(player)
        self:PopulateUserProfile(player)
    end

    game.Players.PlayerAdded:Connect(onPlayerAdded)
    game.Players.PlayerRemoving:Connect(function(player)
        local state = StateService.Store:getState()

        if state.profiles[tostring(player.UserId)] then
            StateService.Store:dispatch({ type = "removeProfile", player = player })
        end
    end)

    table.foreachi(game.Players:GetPlayers(), function(_, player)
        task.spawn(onPlayerAdded, player)
    end)

    Hook = require(game.ServerScriptService.DiscordWebhook).new(AuthService.WebhookURL.id, AuthService.WebhookURL.token)
    FormatHelper = Hook:GetFormatHelper()
end

function ScoreService:_GetGraphKey(userId, songMD5Hash)
    return string.format("Graph(%s%s)", userId, songMD5Hash)
end

function ScoreService:GetPlayerScores(userId, limit)
    local documents = Raxios.get(url "/scores/player", {
        query = { userid = userId, auth = AuthService.APIKey }
    }):json()

    for _, score in ipairs(documents) do
        if typeof(score.Rating) == "number" or typeof(score.Rating) == "nil" then
            score.Rating = { Overall = score.Rating or 0 }
        end
    end

    return documents
end

function ScoreService:CalculateRating(scores)
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

function ScoreService:CalculateAverageAccuracy(scores)
    local accuracy = 0

    for _, score in ipairs(scores) do
        accuracy += score.Accuracy
    end

    return accuracy / #scores
end

function ScoreService:GetProfile(player, userId)
    if RateLimitService:CanProcessRequestWithRateLimit(player, "GetProfile", 2) then
        local profile = Raxios.get(url "/profiles", {
            query = { userid = userId or player.UserId, auth = AuthService.APIKey }
        }):json()

        if typeof(profile.Rating) == "number" then
            return { error = "No scores found" }
        end

        return profile
    end

    return {}
end

function ScoreService.Client:SubmitScore(player, data)
    if RateLimitService:CanProcessRequestWithRateLimit(player, "SubmitScore", 1) then
        Raxios.post(url "/scores", {
            query = {
                userid = player.UserId,
                auth = AuthService.APIKey
            },
            data = {
                UserId = player.UserId,
                PlayerName = player.Name,
                Rating = data.Rating,
                Score = data.Score,
                Marvelouses = data.Marvelouses,
                Perfects = data.Perfects,
                Greats = data.Greats,
                Goods = data.Goods, 
                Bads = data.Bads,
                Misses = data.Misses,
                Mean = data.Mean,
                Accuracy = data.Accuracy,   
                Rate = data.Rate,
                MaxChain = data.MaxChain,
                SongMD5Hash = data.SongMD5Hash,
                Mods = data.Mods
            }
        })

        ScoreService:PopulateUserProfile(player, true)

        local message = Hook:NewMessage()
        local embed = message:NewEmbed()
        local playStatsField = embed:NewField()

        local key = SongDatabase:get_key_for_hash(data.SongMD5Hash)

        --MESSAGE
        message:SetUsername('SCOREMASTER')
        message:SetTTS(false)
        
        --EMBED
        embed:SetURL("https://www.roblox.com/users/" .. player.UserId .."/profile")
        embed:SetTitle("New play submitted by " .. player.Name)
        embed:SetColor3(Color3.fromRGB(math.random(0, 255), math.random(0, 255),math.random(0, 255))) -- this is bad
        embed:AppendFooter("this is a certified hood classic")

        --PLAYSTATSFIELD
        playStatsField:SetName("Play Stats")
        playStatsField:AppendLine("Map: " .. FormatHelper:CodeblockLine(SongDatabase:get_title_for_key(key)))
        playStatsField:AppendLine("Rating: " .. FormatHelper:CodeblockLine(data.Rating.Overall))-- yeet
        playStatsField:AppendLine("Score: " .. FormatHelper:CodeblockLine(data.Score))
        playStatsField:AppendLine("Accuracy : " .. FormatHelper:CodeblockLine(data.Accuracy))
        playStatsField:AppendLine("Rate: " .. FormatHelper:CodeblockLine(data.Rate))
        playStatsField:AppendLine("Spread: " .. FormatHelper:CodeblockLine(data.Marvelouses .. " / " .. data.Perfects .. " / " ..data.Greats .. " / " ..data.Goods .. " / " .. data.Bads .. " / " ..data.Misses))

        message:Send()
    end
    print("Webhook posted")
end

function ScoreService.Client:SubmitGraph(player, songMD5Hash, graph)
    if RateLimitService:CanProcessRequestWithRateLimit(player, "SubmitGraph", 1) then
        local key = ScoreService:_GetGraphKey(player.UserId, songMD5Hash)

        GraphDataStore:SetAsync(key, graph)
    end
end

function ScoreService.Client:GetGraph(player, userId, songMD5Hash)
    if RateLimitService:CanProcessRequestWithRateLimit(player, "GetGraph", 2) then
        local key = ScoreService:_GetGraphKey(userId, songMD5Hash)
        return GraphDataStore:GetAsync(key)
    end
    
    return {}
end

function ScoreService.Client:GetScores(player, songMD5Hash, limit, songRate)
    if RateLimitService:CanProcessRequestWithRateLimit(player, "GetScores", 2) then
        local scores = Raxios.get(url "/scores", {
            query = { hash = songMD5Hash, limit = limit, rate = songRate, auth = AuthService.APIKey }
        }):json()

        for _, score in ipairs(scores) do
            if typeof(score.Rating) == "number" or typeof(score.Rating) == "nil" then
                score.Rating = { Overall = score.Rating or 0 }
            end
        end

        return scores
    end

    return {}, false
end

function ScoreService.Client:GetProfile(player, userId)
    return ScoreService:GetProfile(player, userId)
end

function ScoreService.Client:GetGlobalLeaderboard(player)
    if RateLimitService:CanProcessRequestWithRateLimit(player, "GetGlobalLeaderboard", 3) then
        local leaderboard = Raxios.get(url "/profiles/top", {
            query = { auth = AuthService.APIKey }
        }):json()

        for _, slot in ipairs(leaderboard) do
            if typeof(slot.Rating) == "number" or typeof(slot.Rating) == "nil" then
                slot.Rating = { Overall = slot.Rating or 0 }
            end
        end

        return leaderboard
    end

    return {}
end

function ScoreService.Client:GetPlayerScores(player, userId)
    if RateLimitService:CanProcessRequestWithRateLimit(player, "GetPlayerScores", 2) then
        return ScoreService:GetPlayerScores(userId or player.UserId)
    end
end

function ScoreService.Client:DeleteScore(moderator, objectId)
    if RateLimitService:CanProcessRequestWithRateLimit(moderator, "DeleteScore", 4) and PermissionsService:HasModPermissions(moderator) then
        return Raxios.delete(url "/scores", {
            query = { id = objectId, auth = AuthService.APIKey }
        }):json()
    end
end

return ScoreService
