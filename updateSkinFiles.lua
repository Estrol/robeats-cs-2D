local place = remodel.readPlaceFile("build.rbxlx")

local skins = place.ReplicatedStorage.Skins

for _, skin in ipairs(skins:GetChildren()) do
    remodel.writeModelFile(skin, string.format("./src/ReplicatedStorage/Skins/%s.rbxmx", skin.Name))
end