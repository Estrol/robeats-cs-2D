local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local InsertService = game:GetService("InsertService")

local RateLimitService
local AuthService

local Raxios

local url = require(game.ServerScriptService.URLs)

local MapService = Knit.CreateService {
    Name = "MapService";
    Client = {};
}

function MapService:KnitStart()
    AuthService = Knit.GetService("AuthService")
    RateLimitService = Knit.GetService("RateLimitService")

    Raxios = require(game.ReplicatedStorage.Packages.Raxios)

    local existing_maps = workspace:FindFirstChild("Songs")
    
    if not existing_maps then
        local maps = InsertService:LoadAsset(6485121344)
        local song_maps = maps.Songs
        song_maps.Name = "Songs"
        song_maps.Parent = workspace
    
        maps:Destroy()
    end
end

function MapService.Client:GetPage(player, page)
    if RateLimitService:CanProcessRequestWithRateLimit(player, "GetPage", 3) then
        return Raxios.get(url "/maps", {
            query = { auth = AuthService.APIKey, page = page }
        }):json()
    end
end

return MapService