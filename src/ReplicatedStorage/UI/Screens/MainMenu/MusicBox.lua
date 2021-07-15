local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local Flipper = require(game.ReplicatedStorage.Packages.Flipper)

local Gradient = require(game.ReplicatedStorage.Shared.Gradient)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedImageButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageButton)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)

function noop() end

local MusicBox = Roact.Component:extend("MusicBox")

MusicBox.defaultProps = {
    currentAudioName = "nil",
    currentAudioArtist = "",
    currentAudioSongCover = "rbxassetid://6998234944",
    onClick = noop
}

function MusicBox:getGradient()
    local gradient = Gradient:new()

    for i = 0, 1, 0.1 do
        gradient:add_number_keypoint(i, i)
    end

    return gradient:number_sequence()
end

function MusicBox:render()
        return e(RoundedFrame, {
            Name = "Profile";
            Size = self.props.Size;
            Position = self.props.Position,
            BackgroundColor3 = Color3.fromRGB(17,17,17);
            ZIndex = 1;
            AnchorPoint = Vector2.new(0, 0),
        }, {
            Corner = e("UICorner",{
                CornerRadius = UDim.new(0,4);
            });
    
            SongName = e(RoundedTextLabel,{
                Name = "SongName";
                Text = string.format("%s", self.props.currentAudioName);
                TextColor3 = Color3.fromRGB(255,255,255);
                TextScaled = true;
                Position = UDim2.fromScale(.5, .06);
                Size = UDim2.fromScale(.5,.25);
                AnchorPoint = Vector2.new(0.5,0);
                BackgroundTransparency = 1;
                Font = Enum.Font.GothamSemibold;
                ZIndex = 2;
                LineHeight = 1;
                TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
                TextStrokeTransparency = .5;
            });
    
            Play = e(RoundedImageButton,{
                Name = "ProfileImage";
                AnchorPoint = Vector2.new(0.5,0);
                AutomaticSize = Enum.AutomaticSize.None;
                BackgroundColor3 = Color3.fromRGB(11,11,11);
                BackgroundTransparency = 1;
                Position = UDim2.fromScale(.475, .5);
                Size = UDim2.fromScale(0.09, 0.3);
                HoldSize = UDim2.fromScale(0.125, 0.325),
                Image = "rbxassetid://51811789";
                ImageColor3 = Color3.fromRGB(255,255,255);
                ScaleType = Enum.ScaleType.Fit;
                SliceScale = 10;
                shrinkBy = 0.025;
                Frequency = 7.5,
                dampingRatio = 3;
                OnClick = self.props.onClick
            });
    
            SongCover = e(RoundedImageLabel, {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(15, 15, 15),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                Image = self.props.currentAudioSongCover,
                ScaleType = Enum.ScaleType.Crop,
            }, {
                Corner = e("UICorner", {
                    CornerRadius = UDim.new(0,4)
                });
                Gradient = e("UIGradient", {
                    Transparency = self:getGradient()
                });
            });
        });
end

return MusicBox