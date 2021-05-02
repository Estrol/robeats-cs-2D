local Roact = require(game.ReplicatedStorage.Packages.Roact)
local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)

local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local SongButton = Roact.Component:extend("SongButton")

local function noop() end

SongButton.defaultProps = {
    OnClick = noop
}

function SongButton:init()
    self.motor = Flipper.SingleMotor.new(0)
    self.motorBinding = RoactFlipper.getBinding(self.motor)
end

function SongButton:didMount()
    self.motor:setGoal(Flipper.Spring.new(1, {
        frequency = 4.5;
        dampingRatio = 1.5;
    }))
end

function SongButton:render()
    if SongDatabase:contains_key(self.props.SongKey) == false then
        return nil
    end

    return Roact.createElement(RoundedTextButton, {
        BackgroundTransparency = self.motorBinding:map(function(a)
            return math.clamp(1-a, 0, 0.58)
        end);
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        BorderMode = Enum.BorderMode.Inset,
        BorderSizePixel = 0,
        Position = self.props.Position,
        Size = UDim2.new(1, 0, 0, 75),
        OnClick = function()
            self.props.OnClick(self.props.SongKey)
        end;
        AnchorPoint = self.props.AnchorPoint,
        Text = "";
        HoldSize = UDim2.new(0.98, 0, 0, 72);
        ZIndex = 4;
        LayoutOrder = self.props.SongKey;
    }, {
        SongCover = Roact.createElement("ImageLabel", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1;
            BorderSizePixel = 0,
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.new(0.5, 0, 1, 0),
            ScaleType = Enum.ScaleType.Crop,
            Image = SongDatabase:get_image_for_key(self.props.SongKey)
        }, {
            Roact.createElement("UIGradient", {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.75, 0.9),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Rotation = 180
            }),
            Roact.createElement("UICorner", {
                CornerRadius = UDim.new(0, 4),
            }),
        }),
        DifficultyDisplay = Roact.createElement("TextLabel", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.0199999847, 0, 0.78, 0),
            Size = UDim2.new(0.462034643, 0, 0.11, 0),
            Font = Enum.Font.GothamSemibold,
            Text = string.format("Difficulty: %d", SongDatabase:get_difficulty_for_key(self.props.SongKey)),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextScaled = true,
            TextSize = 16,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, {
            Roact.createElement("UITextSizeConstraint", {
                MaxTextSize = 18,
                MinTextSize = 10,
            });
        }),
        TitleDisplay = Roact.createElement("TextLabel", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.02, 0, 0.1, 0),
            Selectable = true,
            Size = UDim2.new(0.45, 0, 0.3, 0),
            Font = Enum.Font.GothamBold,
            Text = SongDatabase:get_title_for_key(self.props.SongKey),
            TextColor3 = Color3.fromRGB(255, 208, 87),
            TextScaled = true,
            TextSize = 26,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, {
            Roact.createElement("UITextSizeConstraint", {
                MaxTextSize = 26,
            })
        }),
        ArtistDisplay = Roact.createElement("TextLabel", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.02, 0, 0.415, 0),
            Selectable = true,
            Size = UDim2.new(0.45, 0, 0.2, 0),
            Font = Enum.Font.Gotham,
            Text = SongDatabase:get_artist_for_key(self.props.SongKey),
            TextColor3 = Color3.fromRGB(255, 208, 87),
            TextScaled = true,
            TextSize = 26,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, {
            Roact.createElement("UITextSizeConstraint", {
                MaxTextSize = 26,
            })
        })
    })
end

return SongButton
