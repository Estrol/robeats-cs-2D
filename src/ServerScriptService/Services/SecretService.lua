local Knit = require(game:GetService("ReplicatedStorage").Knit)
local DataStoreService = require(game.ReplicatedStorage.Packages.DataStoreService)
local SecretStore = DataStoreService:GetDataStore("SecretDatastore")

local SecretService = Knit.CreateService {
    Name = "SecretService";
    Client = {};
}

function SecretService:GetSecret(secretKey)
    warn("Calls to :GetSecret are NOT CACHED! Please use this method sparingly.")

    return SecretStore:GetAsync(secretKey)
end

function SecretService:SetSecret(secretKey, secretValue)
    SecretStore:SetAsync(secretKey, secretValue)
end

return SecretService