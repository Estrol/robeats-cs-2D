local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)
local EnvironmentSetup = require(game.ReplicatedStorage.RobeatsGameCore.EnvironmentSetup)

local e = Roact.createElement

local PlayerProfile = require(script.PlayerProfile)
local AudioVisualizer = require(script.AudioVisualizer)
local MusicBox = require(script.MusicBox)

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)

local Trove = require(game.ReplicatedStorage.Packages.Trove)

local Actions = require(game.ReplicatedStorage.Actions)

local MainMenuUI = Roact.Component:extend("MainMenuUI")

function MainMenuUI:init()
    self:setState({
        currSFXName = SongDatabase:get_data_for_key(self.props.songKey).AudioFilename,
        currSFXArtistName = SongDatabase:get_data_for_key(self.props.songKey).AudioArtist,
        currSFXBackground = SongDatabase:get_data_for_key(self.props.songKey).AudioCoverImageAssetId
    })

    self.previewController = self.props.previewController

    self.trove = Trove.new()

    local preview = self.previewController:GetSoundInstance()

    self:setState({
        playing = preview.IsPlaying
    })

    local played = preview.Played:Connect(function()
        self:setState({
            playing = true
        })
    end)

    local resumed = preview.Resumed:Connect(function()
        self:setState({
            playing = true
        })
    end)

    local paused = preview.Paused:Connect(function()
        self:setState({
            playing = false
        })
    end)

    local stopped = preview.Stopped:Connect(function()
        self:setState({
            playing = false
        })
    end)

    self.trove:Add(played)
    self.trove:Add(resumed)
    self.trove:Add(paused)
    self.trove:Add(stopped)

    EnvironmentSetup:set_gui_inset(true)
end

function MainMenuUI:didMount()
    self.previewController:PlayId(SongDatabase:get_data_for_key(self.props.songKey).AudioAssetId)
    self.soundObj = self.props.previewController:GetSoundInstance()
end

function MainMenuUI:render()
    local moderation

    if self.props.permissions.isAdmin then
        moderation = e(RoundedTextButton, {
            BackgroundColor3 = Color3.fromRGB(22, 22, 22);
            BorderMode = Enum.BorderMode.Inset,
            BorderSizePixel = 0,
            Size = UDim2.new(0.1,0,0.075,0),
            HoldSize = UDim2.new(0.1,-3,0.075,0),
            Position = UDim2.fromScale(0.975, 0.85),
            AnchorPoint = Vector2.new(1, 0.5),
            Text = "Moderator";
            TextScaled = true;
            TextColor3 = Color3.fromRGB(255, 255, 255);
            LayoutOrder = 4;
            OnClick = function()
                self.props.history:push("/moderation/home")
            end
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MinTextSize = 8;
                MaxTextSize = 13;
            })
        });
    end

    return e(RoundedImageLabel, {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.fromScale(0.5,0.5),
        AnchorPoint = Vector2.new(0.5,0.5),
        --Image = "rbxassetid://6859763885",
        Image = "http://www.roblox.com/asset/?id=8574590582",
        ImageColor3 = Color3.fromRGB(100,100,100)
    }, {
        Logo = e(RoundedImageLabel, {
            Image = "rbxassetid://6224561143";
            Size = UDim2.fromScale(0.4, 0.9);
            Position = UDim2.fromScale(0.02, 0.55);
            AnchorPoint = Vector2.new(0.05, 0.7);
            BackgroundTransparency = 1;
        }, {
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 1;
                AspectType = Enum.AspectType.ScaleWithParentSize
            })
        });
        PlayerProfile = e(PlayerProfile, {
            ShowRank = true
        }),
        AudioVisualizer = e(AudioVisualizer),
        SongBox = e(MusicBox, {
            Size = UDim2.fromScale(0.35, 0.1648);
            Position = UDim2.fromScale(0.025, 0.02);
            SongKey = self.props.songKey;
            Playing = self.state.playing;
            OnPauseToggle = function()
                if self.soundObj.IsPlaying then
                    self.soundObj:Pause()
                else
                    self.soundObj:Resume()
                end
            end,
            OnBack = function()
                local newSongKey = math.clamp(self.props.songKey - 1, 1, SongDatabase:get_key_count())

                self.props.setSongKey(newSongKey)

                self:fadePreview(newSongKey)
            end,
            OnNext = function()
                local newSongKey = math.clamp(self.props.songKey + 1, 1, SongDatabase:get_key_count())

                self.props.setSongKey(newSongKey)

                self:fadePreview(newSongKey)
            end
        }),
        ButtonContainer = e(RoundedFrame, {
            Size = UDim2.fromScale(0.25, 0.6);
            Position = UDim2.fromScale(0.02, 0.35);
            BackgroundTransparency = 1;
        },{
            UIListLayout = e("UIListLayout", {
                Padding = UDim.new(0, 10);
                SortOrder = Enum.SortOrder.LayoutOrder;
                VerticalAlignment = Enum.VerticalAlignment.Bottom;
            });
            PlayButton = e(RoundedTextButton, {
                TextXAlignment = Enum.TextXAlignment.Left;
                BackgroundColor3 = Color3.fromRGB(22, 22, 22);
                BorderMode = Enum.BorderMode.Inset,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 0.1),
                Text = "  Play";
                TextScaled = true;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                LayoutOrder = 1;
                HoldSize = UDim2.fromScale(1, 0.11),
                Tooltip = "Play some songs!",
                OnClick = function()
                    self.props.history:push("/select")
                end
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MinTextSize = 10;
                    MaxTextSize = 18;
                }),
                UIStroke = e("UIStroke", {
                    Thickness = 2;
                    Color = Color3.fromRGB(100, 100, 100);
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
            });
            ScoresButton = e(RoundedTextButton, {
                TextXAlignment = Enum.TextXAlignment.Left;
                BackgroundColor3 = Color3.fromRGB(22, 22, 22);
                BorderMode = Enum.BorderMode.Inset,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 0.1),
                Text = "  Your Scores";
                TextScaled = true;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                LayoutOrder = 3;
                HoldSize = UDim2.fromScale(1, 0.11),
                Tooltip = "View your scores.",
                OnClick = function()
                    self.props.history:push("/scores")
                end
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MinTextSize = 10;
                    MaxTextSize = 18;
                }),
                UIStroke = e("UIStroke", {
                    Thickness = 2;
                    Color = Color3.fromRGB(100, 100, 100);
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
            });

            OptionsButton = e(RoundedTextButton, {
                TextXAlignment = Enum.TextXAlignment.Left;
                BackgroundColor3 = Color3.fromRGB(22, 22, 22);
                BorderMode = Enum.BorderMode.Inset,
                BorderSizePixel = 0,
                Size = UDim2.new(1,0,0.1,0),
                Text = "  Options";
                TextScaled = true;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                LayoutOrder = 2;
                HoldSize = UDim2.fromScale(1, 0.11),
                Tooltip = "Customize your experience.",
                OnClick = function()
                    if not self.props.location.state.OptionsVisible then
                        self.props.history:push("/", {
                            OptionsVisible = true
                        })
                    end
                end
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MinTextSize = 10;
                    MaxTextSize = 18;
                }),
                UIStroke = e("UIStroke", {
                    Thickness = 2;
                    Color = Color3.fromRGB(100, 100, 100);
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
            });
            GlobalLeaderboardButton = e(RoundedTextButton, {
                TextXAlignment = Enum.TextXAlignment.Left;
                BackgroundColor3 = Color3.fromRGB(22, 22, 22);
                BorderMode = Enum.BorderMode.Inset,
                BorderSizePixel = 0,
                Size = UDim2.new(1,0,0.1,0),
                Text = "  Global Ranks";
                TextScaled = true;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                LayoutOrder = 4;
                HoldSize = UDim2.fromScale(1, 0.11),
                Tooltip = "See who's on top!",
                OnClick = function()
                    self.props.history:push("/rankings")
                end
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MinTextSize = 10;
                    MaxTextSize = 18;
                }),
                UIStroke = e("UIStroke", {
                    Thickness = 2;
                    Color = Color3.fromRGB(100, 100, 100);
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
            });
            MultiButton = e(RoundedTextButton, {
                TextXAlignment = Enum.TextXAlignment.Left;
                BackgroundColor3 = Color3.fromRGB(22, 22, 22);
                BorderMode = Enum.BorderMode.Inset,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 0.1),
                Text = "  Multiplayer";
                TextScaled = true;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                LayoutOrder = 5;
                HoldSize = UDim2.fromScale(1, 0.11),
                Tooltip = "Play with others in real time!",
                OnClick = function()
                    self.props.history:push("/multiplayer")
                end
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MinTextSize = 10;
                    MaxTextSize = 18;
                }),
                UIStroke = e("UIStroke", {
                    Thickness = 2;
                    Color = Color3.fromRGB(100, 100, 100);
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
            }),
            SpectatingButton = e(RoundedTextButton, {
                TextXAlignment = Enum.TextXAlignment.Left;
                BackgroundColor3 = Color3.fromRGB(22, 22, 22);
                BorderMode = Enum.BorderMode.Inset,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 0.1),
                Text = "  Spectate";
                TextScaled = true;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                LayoutOrder = 6;
                HoldSize = UDim2.fromScale(1, 0.11),
                Tooltip = "Watch others play!",
                OnClick = function()
                    self.props.history:push("/spectate")
                end
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MinTextSize = 10;
                    MaxTextSize = 18;
                }),
                UIStroke = e("UIStroke", {
                    Thickness = 2;
                    Color = Color3.fromRGB(100, 100, 100);
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                })
            }),
        });
        Title = e("TextLabel", {
            BackgroundTransparency = 1;
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            Text = "RoBeats Community Server";
            TextSize = 10;
            TextXAlignment = Enum.TextXAlignment.Right;
            TextColor3 = Color3.fromRGB(255, 255, 255);
            Size = UDim2.fromScale(0.01, 0.01);
            Position = UDim2.fromScale(0.99, 0.93);
            AnchorPoint = Vector2.new(1, 0);
            Font = Enum.Font.GothamBlack;
        });
        Moderation = moderation
    }); 
end

function MainMenuUI:willUnmount()
    self.props.previewController:Silence()
    self.trove:Destroy()
end

function MainMenuUI:fadePreview(songKey)
    self.props.previewController:PlayId(SongDatabase:get_data_for_key(songKey).AudioAssetId, function(audio)
        audio.TimePosition = audio.TimeLength * 0.33
    end)
end

local Injected = withInjection(MainMenuUI, {
    previewController = "PreviewController"
})

return RoactRodux.connect(function(state)
    return {
        songKey = state.options.transient.SongKey,
        permissions = state.permissions
    }
end,
function(dispatch)
    return {
        setSongKey = function(key)
            dispatch(Actions.setTransientOption("SongKey", key))
        end
    }
end)(Injected)