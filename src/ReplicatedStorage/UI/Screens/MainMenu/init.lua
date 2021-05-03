local Roact = require(game.ReplicatedStorage.Packages.Roact)

local PlayerProfile = require(script.PlayerProfile)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)


local MainMenuUI = Roact.Component:extend("MainMenuUI")

function MainMenuUI:render()
    return Roact.createElement(RoundedFrame, {
        Size = UDim2.new(1, 0, 1, 0),
    }, {
        Logo = Roact.createElement(RoundedImageLabel, {
            Image = "rbxassetid://6224561143";
            Size = UDim2.fromScale(0.4, 0.9);
            Position = UDim2.fromScale(0.02, 0.57);
            AnchorPoint = Vector2.new(0.05, 0.5);
            BackgroundTransparency = 1;
        }, {
            UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
                AspectRatio = 1;
                AspectType = Enum.AspectType.ScaleWithParentSize
            })
        });
        PlayerProfile = Roact.createElement(PlayerProfile, {
            Size = UDim2.fromScale(0.45, 0.2)
        }),
        ButtonContainer = Roact.createElement(RoundedFrame, {
            Size = UDim2.fromScale(0.25, 0.6);
            Position = UDim2.fromScale(0.02,0.95);
            AnchorPoint = Vector2.new(0, 1);
            BackgroundTransparency = 1;
        },{
            UIListLayout = Roact.createElement("UIListLayout", {
                Padding = UDim.new(0.015,0);
                SortOrder = Enum.SortOrder.LayoutOrder;
                VerticalAlignment = Enum.VerticalAlignment.Bottom;
            });

            PlayButton = Roact.createElement(RoundedTextButton, {
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
                UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
                    MinTextSize = 8;
                    MaxTextSize = 13;
                })
            });
            OptionsButton = Roact.createElement(RoundedTextButton, {
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
                UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
                    MinTextSize = 8;
                    MaxTextSize = 13;
                })
            });
            GlobalLeaderboardButton = Roact.createElement(RoundedTextButton, {
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
                UITextSizeConstraint = Roact.createElement("UITextSizeConstraint", {
                    MinTextSize = 8;
                    MaxTextSize = 13;
                })
            });
        });

        Title = Roact.createElement("TextLabel", {
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