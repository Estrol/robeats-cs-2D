local Flipper = require(game.ReplicatedStorage.Packages.Flipper)

local Knit = require(game:GetService("ReplicatedStorage").Knit)

local PreviewController = Knit.CreateController { Name = "PreviewController" }

local function noop() end

local Audio
local AudioVolumeMotor

function PreviewController:KnitInit()
    Audio = Instance.new("Sound")
    Audio.Looped = true
    Audio.Parent = game.SoundService

    AudioVolumeMotor = Flipper.SingleMotor.new(0)
end

function PreviewController:KnitStart()
    AudioVolumeMotor:onStep(function(a)
        Audio.Volume = a
    end)    
end

function PreviewController:PlayId(id, callback, volume)
    if Audio.SoundId == id then
        self:Speak()
        return
    end

    callback = callback or noop
    AudioVolumeMotor:setGoal(Flipper.Instant.new(0))

    Audio.SoundId = id

    local con
    con = Audio.Loaded:Connect(function()
        con:Disconnect()
        callback(Audio)

        Audio:Play()

        -- Start animating the volume
        self:Speak(volume)
    end)

    return Audio
end

function PreviewController:SetRate(rate)
    Audio.PlaybackSpeed = rate
end

function PreviewController:Silence()
    AudioVolumeMotor:setGoal(Flipper.Spring.new(0, {
        frequency = 7,
        dampingRatio = 6
    }))
end

function PreviewController:Speak(volume)
    volume = volume or 0.5
    AudioVolumeMotor:setGoal(Flipper.Spring.new(volume, {
        frequency = 2.7,
        dampingRatio = 6
    }))
end

return PreviewController