local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)
local e = Roact.createElement

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)
local ButtonLayout = require(game.ReplicatedStorage.UI.Components.Base.ButtonLayout)

local RankSlot = Roact.Component:extend("RankSlot")

RankSlot.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    Data = {
        TotalMapsPlayed = 0,
        Rating = 0,
        PlayerName = "Player1",
        UserId = 0,
        Accuracy = 0,
        Place = 1
    },
    OnBan = function() end
}

function RankSlot:init()
    self.moderationService = self.props.moderationService

    self.motor = Flipper.SingleMotor.new(0)
    self.motorBinding = RoactFlipper.getBinding(self.motor)

    self:setState({
        dialogOpen = false
    })
end

function RankSlot:didUpdate()
    self.motor:setGoal(Flipper.Spring.new(self.state.dialogOpen and 1 or 0, {
        dampingRatio = 2.5,
        frequency = 12
    }))
end

function RankSlot:render()    
    return Roact.createElement(RoundedTextButton, {
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderMode = Enum.BorderMode.Inset,
        BorderSizePixel = 0,
        Size = self.props.Size,
        HoldSize = self.props.HoldSize,
        Text = "",
        LayoutOrder = self.props.Data.Place,
        OnRightClick = function()
            if self.props.IsAdmin then
                self:setState(function(state)
                    return {
                        dialogOpen = not state.dialogOpen
                    }
                end)
            end
        end;
    }, {
        Dialog = e(ButtonLayout, {
            Size = UDim2.fromScale(1, 1),
            Position = self.motorBinding:map(function(a)
                return UDim2.fromScale(1, 0):Lerp(UDim2.fromScale(0, 0), a)
            end),
            Padding = UDim.new(0, 8),
            DefaultSpace = 2,
            MaxTextSize = 15,
            Visible = self.motorBinding:map(function(a)
                return a > 0
            end),
            Buttons = {
                {
                    Text = "Ban user",
                    Color = Color3.fromRGB(240, 184, 0),
                    OnClick = function()
                        self.props.OnBan(self.props.Data.UserId, self.props.Data.PlayerName)
                    end
                },
                {
                    Text = "Back",
                    Color = Color3.fromRGB(37, 37, 37),
                    OnClick = function()
                        self:setState(function(state)
                            return {
                                dialogOpen = not state.dialogOpen
                            }
                        end)
                    end
                }
            }
        }),
        UserThumbnail = Roact.createElement(RoundedImageLabel, {
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Position = UDim2.new(0.09, 0, 0.5, 0),
            Size = UDim2.new(0.07, 0, 0.75, 0),
            Image = string.format("https://www.roblox.com/headshot-thumbnail/image?userid=%d&width=420&height=420&format=png", self.props.Data.UserId)
        }, {
            Roact.createElement("UIAspectRatioConstraint", {
                AspectType = Enum.AspectType.ScaleWithParentSize,
                DominantAxis = Enum.DominantAxis.Height,
            }),
            Data = Roact.createElement(RoundedTextLabel, {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(1.25, 0, 0.6, 0),
                Size = UDim2.new(8, 0, 0.35, 0),
                Font = Enum.Font.GothamSemibold,
                Text = string.format("Rating: <font color = \"rgb(211, 214, 2)\"><b>%0.2f</b></font> | Overall Accuracy: %0.2f%% | Total Maps Played: %d", self.props.Data.Rating, self.props.Data.Accuracy, self.props.Data.TotalMapsPlayed),
                RichText = true,
                TextColor3 = Color3.fromRGB(80, 80, 80),
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                Roact.createElement("UITextSizeConstraint", {
                    MaxTextSize = 29,
                    MinTextSize = 3,
                })
            }),
            Player = Roact.createElement(RoundedTextLabel, {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Position = UDim2.new(1.25, 0, 0, 0),
                Size = UDim2.new(15.3, 0, 0.55, 0),
                Font = Enum.Font.GothamSemibold,
                Text = self.props.Data.PlayerName,
                TextColor3 = Color3.fromRGB(94, 94, 94),
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                Roact.createElement("UITextSizeConstraint", {
                    MaxTextSize = 49,
                })
            })
        }),

        Place = Roact.createElement(RoundedTextLabel, {
            BackgroundColor3 = Color3.fromRGB(54, 54, 54),
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0.0075, 0.1),
            Size = UDim2.fromScale(0.075, 0.755),
            Font = Enum.Font.GothamBold,
            Text = string.format("#%d", self.props.Data.Place),
            TextColor3 = Color3.fromRGB(71, 71, 70),
            TextScaled = true,
            BackgroundTransparency = 1;
        }, {
            Roact.createElement("UITextSizeConstraint", {
                MaxTextSize = 35,
                MinTextSize = 7,
            }),
        }),
        UIAspectRatioConstraint = Roact.createElement("UIAspectRatioConstraint", {
            AspectRatio = 9,
            AspectType = Enum.AspectType.ScaleWithParentSize,
        })
    })
end

return withInjection(RankSlot, {
    moderationService = "ModerationService"
})