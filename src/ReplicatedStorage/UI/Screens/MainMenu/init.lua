local Roact = require(game.ReplicatedStorage.Packages.Roact)

local e = Roact.createElement

local PlayerProfile = require(script.PlayerProfile)
local MusicBox = require(script.MusicBox)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)


local MainMenuUI = Roact.Component:extend("MainMenuUI")

function MainMenuUI:render()
    return e(RoundedFrame, {
        Size = UDim2.new(1, 0, 1, 0),
    }, {
        Logo = e(RoundedImageLabel, {
            Image = "rbxassetid://6224561143";
            Size = UDim2.fromScale(0.4, 0.9);
            Position = UDim2.fromScale(0.02, 0.57);
            AnchorPoint = Vector2.new(0.05, 0.5);
            BackgroundTransparency = 1;
        }, {
            UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
                AspectRatio = 1;
                AspectType = Enum.AspectType.ScaleWithParentSize
            })
        });
        PlayerProfile = e(PlayerProfile, {
            Size = UDim2.fromScale(0.45, 0.2)
        }),
        -- SongBox = e(MusicBox, {
        --     Position = UDim2.fromScale(0.25, 0.02),
        --     SongKey = 1;
        -- }),
        ButtonContainer = e(RoundedFrame, {
            Size = UDim2.fromScale(0.25, 0.6);
            Position = UDim2.fromScale(0.02,0.95);
            AnchorPoint = Vector2.new(0, 1);
            BackgroundTransparency = 1;
        },{
            UIListLayout = e("UIListLayout", {
                Padding = UDim.new(0.015,0);
                SortOrder = Enum.SortOrder.LayoutOrder;
                VerticalAlignment = Enum.VerticalAlignment.Bottom;
            });

            PlayButton = e(RoundedTextButton, {
                TextXAlignment = Enum.TextXAlignment.Left;
                BackgroundColor3 = Color3.fromRGB(22, 22, 22);
                BorderMode = Enum.BorderMode.Inset,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 0.125),
                Text = "  Play";
                TextScaled = true;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                LayoutOrder = 1;
                HoldSize = UDim2.fromScale(0.95, 0.125),
                OnClick = function()
                    self.props.history:push("/select")
                end
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MinTextSize = 8;
                    MaxTextSize = 13;
                })
            });

            -- MultiButton = e(RoundedTextButton, {
            --     TextXAlignment = Enum.TextXAlignment.Left;
            --     BackgroundColor3 = Color3.fromRGB(70, 69, 69);
            --     BorderMode = Enum.BorderMode.Inset,
            --     BorderSizePixel = 0,
            --     Size = UDim2.fromScale(1, 0.125),
            --     Text = "  Multiplayer (Coming Soon)";
            --     TextScaled = true;
            --     TextColor3 = Color3.fromRGB(255, 255, 255);
            --     LayoutOrder = 1;
            --     HoldSize = UDim2.fromScale(0.95, 0.125),
            --     OnClick = function()
            --         self.props.history:push("/select")
            --     end
            -- }, {
            --     UITextSizeConstraint = e("UITextSizeConstraint", {
            --         MinTextSize = 8;
            --         MaxTextSize = 13;
            --     })
            -- });

            OptionsButton = e(RoundedTextButton, {
                TextXAlignment = Enum.TextXAlignment.Left;
                BackgroundColor3 = Color3.fromRGB(22, 22, 22);
                BorderMode = Enum.BorderMode.Inset,
                BorderSizePixel = 0,
                Size = UDim2.new(1,0,0.125,0),
                Text = "  Options";
                TextScaled = true;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                LayoutOrder = 2;
                HoldSize = UDim2.fromScale(0.95, 0.125),
                OnClick = function()
                    self.props.history:push("/options")
                end
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MinTextSize = 8;
                    MaxTextSize = 13;
                })
            });
            GlobalLeaderboardButton = e(RoundedTextButton, {
                TextXAlignment = Enum.TextXAlignment.Left;
                BackgroundColor3 = Color3.fromRGB(22, 22, 22);
                BorderMode = Enum.BorderMode.Inset,
                BorderSizePixel = 0,
                Size = UDim2.new(1,0,0.125,0),
                Text = "  Global Ranks";
                TextScaled = true;
                TextColor3 = Color3.fromRGB(255, 255, 255);
                LayoutOrder = 3;
                HoldSize = UDim2.fromScale(0.95, 0.125),
                OnClick = function()
                    self.props.history:push("/rankings")
                end
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MinTextSize = 8;
                    MaxTextSize = 13;
                })
            });
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
    });
    
end

return MainMenuUI