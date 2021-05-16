local Knit = require(game:GetService("ReplicatedStorage").Knit)

local PermissionsService = Knit.CreateService {
    Name = "PermissionsService";
    Client = {};
}

function PermissionsService.Client:HasModPermissions(player)
    if game.CreatorType == Enum.CreatorType.Group then
        return player:GetRankInGroup(game.CreatorId) >= 251
    end
    return game.CreatorId == player.UserId
end

return PermissionsService