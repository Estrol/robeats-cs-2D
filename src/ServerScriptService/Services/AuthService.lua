local Knit = require(game.ReplicatedStorage.Packages.Knit)

local AuthService = Knit.CreateService({
    Name = "AuthService",
    Client = {}
})

local DataStoreService

AuthService.APIKey = ""
AuthService.WebhookURL = { id = "1", token = "no", url = "https://urmomisdead.com/api/0832094823905520982390423/balls" }

function AuthService:KnitInit()
    local suc, err = pcall(function()
        DataStoreService = game:GetService("DataStoreService")

        local authStore = DataStoreService:GetDataStore("AuthStore")

        self.APIKey = authStore:GetAsync("APIKey")
        self.WebhookURL = authStore:GetAsync("WebhookURL")
    end)

    if not suc then
        warn("Could not fetch API key due to error: " .. err)
    end
end

return AuthService