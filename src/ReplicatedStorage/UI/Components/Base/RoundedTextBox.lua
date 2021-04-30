local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)

local e = Roact.createElement
local f = Roact.createFragment

local function noop() end

local RoundedTextBox = Roact.Component:extend("RoundedTextBox")\


RoundedTextBox.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    Font = Enum.Font.GothamSemibold;
    Text = "RoundedTextButton";
    TextSize = 18;
    BackgroundColor3 = Color3.fromRGB(29, 29, 29);
    HoldSize = UDim2.fromScale(0.8, 0.8);
    HighlightBackgroundColor3 = Color3.fromRGB(17, 17, 17);
    OnPress = noop;
    OnRelease = noop;
    Frequency = 13;
    dampingRatio = 2.5;

}

function RoundedTextBox:init()
    return noop()
end

function RoundedTextBox:render()
    local props = {
        
    }
end