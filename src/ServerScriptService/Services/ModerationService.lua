local Knit = require(game:GetService("ReplicatedStorage").Knit)

local DebugOut = require(game.ReplicatedStorage.Shared.DebugOut)

local ModerationService = Knit.CreateService {
    Name = "ModerationService";
    Client = {};
}

local RunService

local PermissionsService
local TagService

local ParseServer
local Bans

function ModerationService:OnPlayerAdded(player)
    -- Check if the user's account age is too young to join the game

    if player.AccountAge < 2 and not RunService:IsStudio() then
        player:Kick(string.format("Your account must be older than 2 days to join this game. %d days left", 2 - player.AccountAge))
    end

    -- Query Parse to see if the user is banned

    Bans
        :query()
        :where({
            UserId = player.UserId
        })
        :execute()
        :andThen(function(documents)
            local ban = documents[1]

            if ban then
                player:Kick(ban.Reason)
            end
        end)

    ModerationService:SetTag(player)
end


function ModerationService:KnitStart()
    PermissionsService = Knit.GetService("PermissionsService")
    
    local ParseServerService = Knit.GetService("ParseServerService")
    ParseServer = ParseServerService:GetParse()
    
    Bans = ParseServer.Objects.class("Bans")
    
    game.Players.PlayerAdded:Connect(function(player)
        self:OnPlayerAdded(player)
    end)
    
    for _, player in pairs(game.Players:GetPlayers()) do
        self:OnPlayerAdded(player)
    end
end

function ModerationService:KnitInit()
    RunService = game:GetService("RunService")
    TagService = Knit.GetService("TagService")
end

function ModerationService:SetTag(player)
    if PermissionsService:HasModPermissions(player) then
        TagService:AddTag(player, "STAFF", Color3.fromRGB(255, 100, 115))
    end
end

function ModerationService.Client:BanUser(moderator, userId, reason)
    if PermissionsService:HasModPermissions(moderator) then
        local success, result = ParseServer.Functions.call("ban", {
            userid = userId,
            reason = reason
        })
        :await()

        if success then
            DebugOut:puts("Successfully banned user %d", userId)
        else
            warn("An error occured!\n", result) 
        end

        local player = game.Players:GetPlayerByUserId(userId)

        if player then
            player:Kick(reason)
        end
    end
end

function ModerationService.Client:KickUser(moderator, userId, reason)
    if PermissionsService:HasModPermissions(moderator) then
        local player = game.Players:GetPlayerByUserId(userId)

        if player then
            player:Kick(reason)
        end
    end
end

return ModerationService