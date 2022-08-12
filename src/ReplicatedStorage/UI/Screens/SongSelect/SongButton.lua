local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement
local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)

local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local SongButton = Roact.Component:extend("SongButton")

local function noop() end

local MIN_ID = 5567748245

SongButton.defaultProps = {
    Size = UDim2.new(1, 0, 0, 75),
    OnClick = noop,
    LayoutOrder = 1,
    Selected = false
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

    local song = SongDatabase:get_data_for_key(self.props.SongKey)
    local id = tonumber(string.match(song.AudioAssetId, "rbxassetid://(%d+)")) or MIN_ID

    local difficulty = SongDatabase:get_difficulty_for_key(self.props.SongKey, self.props.SongRate / 100)

    local mapper = SongDatabase:get_mapper_for_key(self.props.SongKey)

    local topSkillsets = {}
    local allSkillsets = {}

    for skillset, skillsetDiff in pairs(difficulty) do
        if skillset == "Rate" or skillset == "Overall" then
            continue
        end

        table.insert(allSkillsets, string.format("%s: %.2f", skillset, skillsetDiff))

        if math.abs(difficulty.Overall - skillsetDiff) < 3 and #topSkillsets < 4 then
            table.insert(topSkillsets, skillset)
        end
    end

    return e(RoundedTextButton, {
        BackgroundTransparency = self.motorBinding:map(function(a)
            return math.clamp(1-a, 0, 0.58)
        end);
        BackgroundColor3 = if self.props.Selected then Color3.fromRGB(30, 95, 85) else if id < MIN_ID then Color3.fromRGB(36, 21, 21) else Color3.fromRGB(22, 22, 22),
        HighlightBackgroundColor3 = if self.props.Selected then Color3.fromRGB(16, 75, 67) else if id < MIN_ID then Color3.fromRGB(31, 18, 18) else nil,
        BorderMode = Enum.BorderMode.Inset,
        BorderSizePixel = 0,
        Size = self.props.Size,
        Position = self.props.Position,
        OnClick = function()
            self.props.OnClick(self.props.SongKey)
        end,
        AnchorPoint = self.props.AnchorPoint,
        Text = "";
        HoldSize = UDim2.new(0.98, 0, 0, 72);
        ZIndex = 4;
        LayoutOrder = self.props.LayoutOrder;
        Tooltip = table.concat(allSkillsets, ", "),
        TooltipOffset = UDim2.fromOffset(10, 30)
    }, {
        SongCover = e("ImageLabel", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1;
            BorderSizePixel = 0,
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.new(0.5, 0, 1, 0),
            ScaleType = Enum.ScaleType.Crop,
            Image = SongDatabase:get_image_for_key(self.props.SongKey)
        }, {
            e("UIGradient", {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.75, 0.9),
                    NumberSequenceKeypoint.new(1, 1)
                }),
                Rotation = 180
            }),
            e("UICorner", {
                CornerRadius = UDim.new(0, 4),
            }),
        }),
        DifficultyDisplay = e("TextLabel", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.0199999847, 0, 0.72, 0),
            Size = UDim2.new(0.462034643, 0, 0.18, 0),
            Font = Enum.Font.GothamSemibold,
            Text = string.format("Difficulty: %0.2f | %s", difficulty.Overall, table.concat(topSkillsets, ", ")),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextScaled = true,
            TextSize = 22,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, {
            e("UITextSizeConstraint", {
                MaxTextSize = 22,
                MinTextSize = 10,
            });
        }),
        TitleDisplay = e("TextLabel", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.02, 0, 0.1, 0),
            Selectable = true,
            Size = UDim2.new(0.7, 0, 0.3, 0),
            Font = Enum.Font.GothamBold,
            Text = SongDatabase:get_title_for_key(self.props.SongKey),
            TextColor3 = Color3.fromRGB(255, 208, 87),
            TextScaled = true,
            TextSize = 26,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, {
            e("UITextSizeConstraint", {
                MaxTextSize = 26,
            })
        }),
        ArtistDisplay = e("TextLabel", {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.02, 0, 0.415, 0),
            Selectable = true,
            Size = UDim2.new(0.45, 0, 0.2, 0),
            Font = Enum.Font.Gotham,
            Text = SongDatabase:get_artist_for_key(self.props.SongKey) .. " // " .. mapper,
            TextColor3 = Color3.fromRGB(255, 208, 87),
            TextScaled = true,
            TextSize = 26,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, {
            e("UITextSizeConstraint", {
                MaxTextSize = 26,
            })
        })
    })
end

return SongButton
