local Knit = require(game.ReplicatedStorage.Packages.Knit)

local SFXController = Knit.CreateController({
    Name = "SFXController"
})

SFXController.BUTTON_CLICK = "rbxassetid://7107162229"
SFXController.BUTTON_HOVER = "rbxassetid://6324801967"

function SFXController:Play(id, volume)
    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = id
        sound.Volume = volume

        sound.Parent = game.SoundService
        sound:Play()
        sound.Ended:Wait()
        sound:Destroy()
    end)
end

return SFXController