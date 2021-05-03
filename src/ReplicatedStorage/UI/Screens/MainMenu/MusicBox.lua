local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)

local Knit = require(game.ReplicatedStorage.Knit)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)
local RoundedImageButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageButton)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)
local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local MusicBox = Roact.Component:extend("MusicBox")

MusicBox.defaultProps = {
    Position = UDim2.fromScale(0.25, 0.02),
    Size = UDim2.fromScale(1, 1);
    AnchorPoint = Vector2.new(0,0);
    SongKey = 87;
}

function MusicBox:init()
    self.soundRef = Roact.createRef()
    
    self.motor = Flipper.GroupMotor.new({
        loudness = 0;
        position = 0;
    })
    self.motorBinding = RoactFlipper.getBinding(self.motor)

    -- store number of keys in a variable because it is too expensive to get the count
    local numOfKeys = SongDatabase:number_of_keys()

    self:setState({
        SongKey = 1; --math.random(1, SongDatabase:number_of_keys());
        isPlaying = true;
    })

    self.switchSongKey = function(increment)
        self:setState(function(state)
            local newIndex = state.SongKey + increment
            if newIndex == 0 then
                return {
                    SongKey = numOfKeys
                }
            elseif newIndex > numOfKeys then
                return {
                    SongKey = 1
                }
            end
            return {
                SongKey = newIndex
            }
        end)
    end
end

function MusicBox:didMount()
    local sound = self.soundRef:getValue()
    
    self.con = SPUtil:bind_to_frame(function()
        self.motor:setGoal({
            loudness = Flipper.Spring.new(sound.PlaybackLoudness, {
                frequency = 8;
                dampingRatio = 1.5;
            });
            position = Flipper.Spring.new(sound.TimePosition/sound.TimeLength, {
                frequency = 5;
                dampingRatio = 3;
            })
        })
    end)
end

function MusicBox:render()
    return e(RoundedFrame, {
        Name = "Profile";
        Size = self.props.Size;
        Position = self.motorBinding:map(function(a)
            return self.props.Position - UDim2.fromOffset(20*(a.loudness/1000), 0)
        end);
        BackgroundColor3 = Color3.fromRGB(17,17,17);
        ZIndex = 1;
        AnchorPoint = self.props.AnchorPoint;
        -- time to win
        -- YES WE WILL WIN
        -- POG , let this be our little secret conversation
    }, {
        Corner = e("UICorner",{
            CornerRadius = UDim.new(0,4);
        });

        SongName = e(RoundedTextLabel,{
            Name = "SongName";
            Text = string.format("%s - %s", SongDatabase:get_artist_for_key(self.state.SongKey), SongDatabase:get_title_for_key(self.state.SongKey));
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
            Position = UDim2.fromScale(.5, .55);
            Size = UDim2.fromScale(0.1, 0.3);
            Image = "rbxassetid://51811789";
            ImageColor3 = Color3.fromRGB(255,255,255);
            ScaleType = Enum.ScaleType.Fit;
            SliceScale = 1;
            shrinkBy = 0.025;
            onActivated = function()
                self:setState(function(state)
                    return {
                        isPlaying = not state.isPlaying;
                    }
                end)
            end
        });

        Back = e(RoundedImageButton, {
            AutomaticSize = Enum.AutomaticSize.None;
            AnchorPoint = Vector2.new(0.5,0);
            BackgroundColor3 = Color3.fromRGB(11,11,11);
            BackgroundTransparency = 1;
            Position = UDim2.fromScale(.35, .55);
            Size = UDim2.fromScale(0.2, 0.3);
            Rotation = 180;
            Image = "rbxassetid://6323574622";
            ScaleType = Enum.ScaleType.Fit;
            SliceScale = 1;
            shrinkBy = 0.025;
            ImageColor3 = Color3.fromRGB(255, 255, 255);
            ImageTransparency = 0.65;
            onActivated = function()
                self.switchSongKey(1)
            end
        });

        Forward = e(RoundedImageButton, {
            AutomaticSize = Enum.AutomaticSize.None;
            AnchorPoint = Vector2.new(0.5,0);
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Position = UDim2.fromScale(.65, .55);
            Size = UDim2.fromScale(0.2, 0.3);
            Image = "rbxassetid://6323574622";
            ScaleType = Enum.ScaleType.Fit;
            SliceScale = 1;
            shrinkBy = 0.025;
            ImageColor3 = Color3.fromRGB(255, 255, 255);
            ImageTransparency = 0.65;
            onActivated = function()
                self.switchSongKey(1)
            end
        });

        SongCover = e("ImageLabel", {
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
            Gradient = e("UIGradient",{
                Transparency = self:getGradient()
            })
        });
    });
end

function MusicBox:willUnmount()
    self.con:Disconnect()
end

return MusicBox