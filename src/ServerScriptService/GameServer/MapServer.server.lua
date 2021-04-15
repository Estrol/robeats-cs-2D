--[[
    Exposes an API for getting map data.

    Credit: kisperal
]]

local Remotes = require(game.ReplicatedStorage.Remotes)

local HttpService = game:GetService("HttpService")

local base_url = "https://apisdfgdfsg.glitch.me"

local get_maps = Remotes.Server:Create("GetMaps")
get_maps:SetCallback(function()
    local headers = {}
    local data = {
        Url = string.format("%s/maps", base_url);
        Method = "GET";
    }

    return HttpService:JSONDecode(HttpService:RequestAsync(data).Body)
end)

local get_hit_data = Remotes.Server:Create("GetHitData")
get_hit_data:SetCallback(function(_, id)
    local data = {
        Url = string.format(base_url.."/maps/objects/%s", id);
        Method = "GET";
    }

    return HttpService:JSONDecode(HttpService:RequestAsync(data).Body).HitObjects
end)