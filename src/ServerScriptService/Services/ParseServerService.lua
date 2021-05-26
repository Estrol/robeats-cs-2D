local Knit = require(game:GetService("ReplicatedStorage").Knit)

local RunService = game:GetService("RunService")

local Promise = require(game.ReplicatedStorage.Knit.Util.Promise)

local DebugOut = require(game.ReplicatedStorage.Shared.DebugOut)
local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local DataStoreService = require(game.ReplicatedStorage.Packages.DataStoreService)
local SecretStore = DataStoreService:GetDataStore("SecretDatastore")

local ParseServer = require(game.ReplicatedStorage.Packages.ParseServer)

local ParseServerService = Knit.CreateService {
    Name = "ParseServerService";
    Client = {};
}


function ParseServerService:KnitStart()
    
end


function ParseServerService:KnitInit()
    self._parse = ParseServer.new()

    local baseUrl

    if RunService:IsStudio() then
        baseUrl = game.ServerScriptService:GetAttribute("UseReleaseAPI") and game:GetService("ServerScriptService").URLs.Release.Value or game:GetService("ServerScriptService").URLs.Dev.Value
    else
        baseUrl = game:GetService("ServerScriptService").URLs.Release.Value
    end
    
    DebugOut:puts("Base API URL: %s", baseUrl)

    local appId
    
    SPUtil:try(function()
        appId = SecretStore:GetAsync("ParseAppId")
    end)

    if appId == nil then appId = "1" end
    
    self._parse:setAppId(appId):setBaseUrl(baseUrl)
end

function ParseServerService:GetParse()
    return self._parse
end

return ParseServerService