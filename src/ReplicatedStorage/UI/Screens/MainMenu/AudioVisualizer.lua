local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)
local e = Roact.createElement
local f = Roact.createFragment

local RunService = game:GetService("RunService")

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)

local AudioVisualizer = Roact.Component:extend("AudioVisualizer")

function AudioVisualizer:init()
    if RunService:IsRunning() then
        self.motor = Flipper.SingleMotor.new(0)
        self.motorBinding = RoactFlipper.getBinding(self.motor)

        local Knit = require(game:GetService("ReplicatedStorage").Knit)
        local PreviewController = Knit.GetController("PreviewController")

        local SoundInstance = PreviewController:GetSoundInstance()

        self.animateLinesPerFrame = SPUtil:bind_to_frame(function()
            self.motor:setGoal(Flipper.Spring.new(SoundInstance.PlaybackLoudness, {
                dampingRatio = 2.75,
                frequency = 8.5
            }))
        end)
    end
end

function AudioVisualizer:render()
    local lines = {}

    local numOfLines = 120

    for i = 1, numOfLines do
        local lineElement = e(RoundedFrame, {
            Size = self.motorBinding:map(function(a)
                a += math.random(-20, 20)

                return UDim2.fromScale(1/numOfLines, a/650)
            end),
            BackgroundColor3 = Color3.fromRGB(39, 39, 39),
            LayoutOrder = i
        })

        table.insert(lines, lineElement)
    end

    return e(RoundedFrame, {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 0.15),
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        ClipsDescendants = true
    }, {
        UIListLayout = e("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        }),
        Lines = f(lines)
    })
end

function AudioVisualizer:willUnmount()
    if self.animateLinesPerFrame then
        self.animateLinesPerFrame:Disconnect()
    end
end

return AudioVisualizer