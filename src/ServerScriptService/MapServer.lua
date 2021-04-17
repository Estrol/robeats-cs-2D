--[[
    Fetches map data and sticks it in Workspace.

    Credit: kisperal
]]

local InsertService = game:GetService("InsertService")

return function()
    local existing_maps = workspace:FindFirstChild("Songs")

    if existing_maps then
        existing_maps:Destroy()
    end

    local maps = InsertService:LoadAsset(6485121344)
    local song_maps = maps.Songs
    song_maps.Parent = workspace

    maps:Destroy()
end
