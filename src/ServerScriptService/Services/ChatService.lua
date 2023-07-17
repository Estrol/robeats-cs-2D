local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local Tiers = require(game.ReplicatedStorage.Tiers)

local Chat

local AssertType

local ChatService = Knit.CreateService {
    Name = "ChatService";
    Client = {};
}

local RateLimitService
local StateService

function ChatService:KnitInit()
    Chat = game:GetService("Chat")

    AssertType = require(game.ReplicatedStorage.Shared.AssertType)

    RateLimitService = Knit.GetService("RateLimitService")
    StateService = Knit.GetService("StateService")
end

function ChatService.Client:Chat(player, channel, message)
    if not RateLimitService:CanProcessRequestWithRateLimit(player, "Chat", 3) then
        return
    end

    message = tostring(message)

    local oldMessage = message

    if player then
        message = Chat:FilterStringForBroadcast(message, player)
    end

    StateService.Store:dispatch({
        type = "addChatMessage",
        channel = channel,
        message = message,
        player = if player then player else { Name = "[SYSTEM]" },
        time = os.time()
    })

    -- this is done in the cheapest and worst way possible because i dont feel like doing any real work at the moment
    if oldMessage == "!roll" then
        self:Chat(nil, channel, "You rolled a 100-sided die! You got: " .. math.random(0, 100))
    elseif oldMessage == "!me" then
        local profile = StateService.Store:getState().profiles[tostring(player.UserId)]
        local tier = Tiers:GetTierFromRating(profile.GlickoRating)

        local summaryTemplate = "%s, your ranked MMR is %d (%s) [#%d]."
        
        if profile then
            self:Chat(nil, channel, string.format(summaryTemplate, profile.PlayerName, profile.GlickoRating, Tiers:GetStringForTier(tier, true), profile.Rank))
        else
            self:Chat(nil, channel, "I couldn't get your stats.")
        end
    end
end

return ChatService