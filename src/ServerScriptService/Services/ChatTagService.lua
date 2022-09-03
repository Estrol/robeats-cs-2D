local Knit = require(game.ReplicatedStorage.Packages.Knit)

local PermissionsService
local ChatService

local ChatTagService = Knit.CreateService {
    Name = "ChatTagService";
    Client = {}
}

function ChatTagService:KnitStart()
    PermissionsService = Knit.GetService("PermissionsService")
    ChatService = require(game.ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))

    ChatService.SpeakerAdded:Connect(function(Speaker)
        self:HandleSpeakerAdded(Speaker)
    end)

    for _, speaker in ipairs(ChatService:GetSpeakerList()) do
        self:HandleSpeakerAdded(speaker)
    end
end

function ChatTagService:HandleSpeakerAdded(speakerName)
    local speaker = ChatService:GetSpeaker(speakerName)
    local player = speaker:GetPlayer()

    if player then
        local data = PermissionsService:GetGroupRole(player)

        if data then
            speaker:SetExtraData("Tags", { data.TagData })
            speaker:SetExtraData("ChatColor", data.ChatColor)
        end
    end
end

return ChatTagService