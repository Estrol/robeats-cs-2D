-- adapted from https://github.com/Sleitnick/AeroGameFramework/blob/master/src/StarterPlayer/StarterPlayerScripts/Aero/Controllers/Fade.lua

local Knit = require(game.ReplicatedStorage.Packages.Knit)
local Promise = require(game.ReplicatedStorage.Packages.Promise)

local FadeController = Knit.CreateController({
	Name = "FadeController"
})


local DEFAULT_DURATION = 0.2


-- ScreenGui:
local fadeGui = Instance.new("ScreenGui")
	fadeGui.Name = "FadeGui"
	fadeGui.DisplayOrder = 9
	fadeGui.ResetOnSpawn = false
	fadeGui.IgnoreGuiInset = true -- Now ignores the inset because what kind of monster would want this off?

-- Main overlay frame:
local fade = Instance.new("Frame")
	fade.Name = "Fade"
	fade.Size = UDim2.new(1, 0, 1, 0)
	fade.Position = UDim2.new(0, 0, 0, 0)
	fade.BorderSizePixel = 0
	fade.BackgroundColor3 = Color3.new(0, 0, 0)
	fade.BackgroundTransparency = 1
	fade.Parent = fadeGui


local easingStyle = Enum.EasingStyle.Quad

local TweenService
local currentTween

function FadeController:KnitStart()
	fadeGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end


function FadeController:KnitInit()
	TweenService = game:GetService("TweenService")
end

-- Set background color:
function FadeController:SetBackgroundColor(c)
	local t = typeof(c)
	if (t == "Color3") then
		fade.BackgroundColor3 = c
	elseif (t == "BrickColor") then
		fade.BackgroundColor3 = c.Color
	else
		error("Argument must be of type Color3 or BrickColor")
	end
end

-- Fade to a transparency, starting at whatever transparency level it is currently:
function FadeController:To(inOut)
	-- If already fading, stop fading so we can prioritize this new fade:
	if (currentTween) then
		currentTween:Cancel()
		currentTween = nil
	end
	
	-- Fade operation:
	local tweenInfo = TweenInfo.new(DEFAULT_DURATION, easingStyle, inOut == "In" and Enum.EasingDirection.In or Enum.EasingDirection.Out)
	
    currentTween = TweenService:Create(fade, tweenInfo, {BackgroundTransparency = inOut == "In" and 0 or 1})

	-- Start fading:
	currentTween:Play()

    return Promise.fromEvent(currentTween.Completed)
end


return FadeController