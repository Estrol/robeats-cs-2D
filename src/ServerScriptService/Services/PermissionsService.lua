local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local RunService = game:GetService("RunService")

local PermissionsService = Knit.CreateService {
    Name = "PermissionsService";
    Client = {};
}

PermissionsService.GROUP_ID = 5863946
PermissionsService.OWNER_ID = 526993347

PermissionsService.IgnoredRoles = {
    "Member",
    "ro[Crazy]",
    "Top 10 (Verified)",
    "Tournament Participant",
    "Designer",
    "Audio Uploader"
}

PermissionsService.Roles = {
    ["Moderator"] = {
        TagData = {TagText = "MOD", TagColor = Color3.fromRGB(146, 218, 245)},
        ChatColor = Color3.fromRGB(230,231,231)
    },

    ["Admin"] = {
        TagData = {TagText = "ADMIN", TagColor = Color3.fromRGB(176, 218, 114)},
        ChatColor = Color3.fromRGB(230,231,231)
    },

    ["Admin+"] = {
        TagData = {TagText = "ADMIN+", TagColor = Color3.fromRGB(107, 250, 107)},
        ChatColor = Color3.fromRGB(181, 255, 255)
    },

    ["Developer"] = {
        TagData = {TagText = "DEV", TagColor = Color3.fromRGB(255, 141, 191)},
        ChatColor = Color3.fromRGB(255, 171, 164)
    },

    ["Owner"] = {
        TagData = {TagText = "OWNER", TagColor = Color3.fromRGB(231, 210, 124)},
        ChatColor = Color3.fromRGB(231, 210, 124)
    }
}

function PermissionsService:GetGroupRole(player : Player)
    if player:IsInGroup(self.GROUP_ID) then
        local role = player:GetRoleInGroup(self.GROUP_ID)
        
        for _, _role in self.IgnoredRoles do
            if role == _role then return end
        end

        if player.UserId == self.OWNER_ID then
            return self.Roles.Owner
        end

        return self.Roles[role]
    end
end

function PermissionsService:HasModPermissions(player : Player)
    if RunService:IsStudio() then
        return true
    end

    if game.CreatorType == Enum.CreatorType.Group then
        return player:GetRankInGroup(game.CreatorId) >= 251
    end
    return game.CreatorId == player.UserId
end

PermissionsService.Client.HasModPermissions = PermissionsService.HasModPermissions

return PermissionsService