-- Packages
local Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
local Knit = require(Packages.Knit)

-- RobloxServices
local MessagingService = game:GetService("MessagingService")
local NotificationService = Knit.CreateService { Name = "NotificationService" }

-- MessagingService Subscriptions
MessagingService:SubscribeAsync("studio_game_update", function(incoming)
    -- Usually going to be a new version #
    assert(incoming.Data.Version, "Expected a version#...?")
    local format = string.format("RCS has updated to version %s\nRCS will teleport you in 2 minutes", incoming.Data.Version)
    -- mreeeewwwww~

    if ( workspace:GetAttribute("CurrentVersion") ~= incoming.Data.Version ) then
        -- Push to client roacts
        NotificationService.Client.OnGameUpdated(format)
    end

end)


local GamePublishAnnouncement = Instance.new("BindableEvent")

if ( game:GetService("RunService"):IsStudio() ) then
    GamePublishAnnouncement.Event:Connect(function(version)
        assert(version, "You cannot tell players that the game has updated without a new version number!")
        MessagingService:PublishAsync("studio_game_update", version)        
    end)
end

return NotificationService