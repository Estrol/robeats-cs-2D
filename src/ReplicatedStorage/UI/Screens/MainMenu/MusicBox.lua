local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

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
    SongKey = 1,
    Playing = false,
    OnPauseToggle = noop,
    OnBack = noop,
    OnNext = noop
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
                Text = string.format("%s - %s", SongDatabase:get_title_for_key(self.props.SongKey), SongDatabase:get_artist_for_key(self.props.SongKey));
                TextColor3 = Color3.fromRGB(255,255,255);
                TextScaled = true;
                Position = UDim2.fromScale(.5, .06);
                Size = UDim2.fromScale(0.9,.25);
                AnchorPoint = Vector2.new(0.5,0);
                BackgroundTransparency = 1;
                Font = Enum.Font.GothamSemibold;
                ZIndex = 2;
                LineHeight = 1;
                TextStrokeColor3 = Color3.fromRGB(0, 0, 0);
                TextStrokeTransparency = .5;
            });
    
            Back = e(RoundedImageButton,{
                Name = "ProfileImage";
                AnchorPoint = Vector2.new(0.5,0.5);
                AutomaticSize = Enum.AutomaticSize.None;
                BackgroundColor3 = Color3.fromRGB(11,11,11);
                BackgroundTransparency = 1;
                Position = UDim2.fromScale(.375, .6);
                Size = UDim2.fromScale(0.05, 0.3);
                HoldSize = UDim2.fromScale(0.05, 0.3);
                Image = "rbxassetid://10369041813";
                ImageColor3 = Color3.fromRGB(255,255,255);
                ScaleType = Enum.ScaleType.Fit;
                SliceScale = 10;
                shrinkBy = 0.025;
                Frequency = 7.5,
                dampingRatio = 3;
                OnClick = self.props.OnBack
            }, {
                UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                    AspectRatio = 1
                })
            });

            Play = e(RoundedImageButton,{
                Name = "ProfileImage";
                AnchorPoint = Vector2.new(0.5,0.5);
                AutomaticSize = Enum.AutomaticSize.None;
                BackgroundColor3 = Color3.fromRGB(11,11,11);
                BackgroundTransparency = 1;
                Position = UDim2.fromScale(.475, .6);
                Size = UDim2.fromScale(0.07, 0.3);
                HoldSize = UDim2.fromScale(0.07, 0.3);
                Image = if self.props.Playing then "rbxassetid://10369148321" else "rbxassetid://10369077887";
                ImageColor3 = Color3.fromRGB(255,255,255);
                ScaleType = Enum.ScaleType.Fit;
                SliceScale = 10;
                shrinkBy = 0.025;
                Frequency = 7.5,
                dampingRatio = 3;
                OnClick = self.props.OnPauseToggle
            }, {
                UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                    AspectRatio = 1
                })
            });

            Next = e(RoundedImageButton,{
                Name = "ProfileImage";
                AnchorPoint = Vector2.new(0.5,0.5);
                AutomaticSize = Enum.AutomaticSize.None;
                BackgroundColor3 = Color3.fromRGB(11,11,11);
                BackgroundTransparency = 1;
                Position = UDim2.fromScale(.575, .6);
                Size = UDim2.fromScale(0.05, 0.3);
                HoldSize = UDim2.fromScale(0.05, 0.3);
                Image = "rbxassetid://10369041813";
                ImageColor3 = Color3.fromRGB(255,255,255);
                ScaleType = Enum.ScaleType.Fit;
                SliceScale = 10;
                Rotation = 180;
                shrinkBy = 0.025;
                Frequency = 7.5,
                dampingRatio = 3;
                OnClick = self.props.OnNext
            }, {
                UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                    AspectRatio = 1
                })
            });
    
            SongCover = e(RoundedImageLabel, {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Color3.fromRGB(15, 15, 15),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                Image = SongDatabase:get_image_for_key(self.props.SongKey),
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