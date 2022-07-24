local Knit = require(game.ReplicatedStorage.Packages.Knit)

local AuthService = Knit.CreateService({
    Name = "AuthService",
    Client = {}
})

local DataStoreService

AuthService.APIKey = ""

function AuthService:KnitInit()
    local suc, err = pcall(function()
        DataStoreService = game:GetService("DataStoreService")

        local authStore = DataStoreService:GetDataStore("AuthStore")

        self.APIKey = authStore:GetAsync("APIKey")
    end)

    if not suc then
        warn("Could not fetch API key due to error: " .. err)
    end
end

return AuthService