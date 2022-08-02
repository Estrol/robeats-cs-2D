local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)
local Grade = require(game.ReplicatedStorage.RobeatsGameCore.Enums.Grade)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)

local Score = Roact.Component:extend("Score")

local function noop() end

Score.defaultProps = {
    OnClick = noop
}

function Score:render()
    local songKey = SongDatabase:get_key_for_hash(self.props.SongMD5Hash)
    
    if songKey == SongDatabase:invalid_songkey() then
        return
    end

    local _, gradeName, gradeColor = Grade:get_grade_from_accuracy(self.props.Accuracy)

    return e(RoundedTextButton, {
        HoldSize = UDim2.new(1, 0, 0, 70),
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        Text = "",
        LayoutOrder = self.props.Place,
        OnClick = self.props.OnClick
    }, {
        Grade = e(RoundedTextLabel, {
            Size = UDim2.fromScale(0.05, 1),
            Position = UDim2.fromScale(0.005, 0),
            TextColor3 = gradeColor,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            BackgroundTransparency = 1,
            RichText = true,
            TextScaled = true,
            Text = gradeName
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 27
            })
        }),
        SongData = e(RoundedTextLabel, {
            Size = UDim2.fromScale(0.9, 0.35),
            Position = UDim2.fromScale(0.055, 0.17),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            RichText = true,
            TextScaled = true,
            Font = Enum.Font.GothamBlack,
            Text = string.format("<font color=\"rgb(255, 249, 64)\">%0.2f</font> | %s - %s [%0.2fx]", self.props.Rating.Overall, SongDatabase:get_title_for_key(songKey), SongDatabase:get_artist_for_key(songKey), self.props.Rate / 100)
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 21
            })
        }),
        ScoreData = e(RoundedTextLabel, {
            Size = UDim2.fromScale(0.9, 0.25),
            Position = UDim2.fromScale(0.055, 0.54),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            RichText = true,
            TextScaled = true,
            Font = Enum.Font.Gotham,
            TextSize = 13,
            Text = string.format("Score: %d | Accuracy: <font color=\"rgb(255, 249, 64)\">%0.2f%%</font> | Mean: %0.2f ms | Max Combo: %d", self.props.Score, self.props.Accuracy, self.props.Mean, self.props.MaxChain)
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 22
            })
        }),
        SongCover = e(RoundedImageLabel, {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1;
            BorderSizePixel = 0,
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.new(0.5, 0, 1, 0),
            ScaleType = Enum.ScaleType.Crop,
            Image = SongDatabase:get_image_for_key(songKey)
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
        UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
            AspectRatio = 14,
            AspectType = Enum.AspectType.ScaleWithParentSize,
            DominantAxis = Enum.DominantAxis.Width
        })
    })
end

return Score