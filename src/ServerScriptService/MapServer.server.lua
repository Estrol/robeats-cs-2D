--[[
    Fetches map data and sticks it in Workspace.

    Credit: kisperal
]]

local InsertService = game:GetService("InsertService")

local existing_maps = workspace:FindFirstChild("Songs")

if not existing_maps then
    local maps = InsertService:LoadAsset(6485121344)
    local song_maps = maps.Songs
    song_maps.Name = "Songs"
    song_maps.Parent = workspace

    maps:Destroy()
end
