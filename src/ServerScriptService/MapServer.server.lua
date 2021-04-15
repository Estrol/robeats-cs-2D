--[[
    Fetches map data and sticks it in Workspace.

    Credit: kisperal
]]

local InsertService = game:GetService("InsertService")

local maps = InsertService:LoadAsset(6485121344)
local song_maps = maps.SongMaps
song_maps.Parent = workspace

maps:Destroy()
