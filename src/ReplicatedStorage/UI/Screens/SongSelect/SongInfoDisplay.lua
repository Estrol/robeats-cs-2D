local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)
local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)
local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)
local Llama = require(game.ReplicatedStorage.Packages.Llama)

local e = Roact.createElement

-- hjsdgrfkhjbsdgfhkjdsfghjbksdfghjbk

local NpsGraph = require(script.Parent.NpsGraph)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)
local RoundedImageLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedImageLabel)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)

local SongInfoDisplay = Roact.Component:extend("SongInfoDisplay")

SongInfoDisplay.defaultProps = {
    Size = UDim2.fromScale(1, 1),
    SongRate = 100
}

local function noop() end

function SongInfoDisplay:init()
    self.onLeaderboardClick = self.props.onLeaderboardClick

    self.motor = Flipper.GroupMotor.new({
        title = 0;
        artist = 0;
    })
    self.motorBinding = RoactFlipper.getBinding(self.motor)
end

function SongInfoDisplay:didUpdate(prevProps)
    if self.props.SongKey ~= prevProps.SongKey then
        self.motor:setGoal({
            title = Flipper.Instant.new(0);
            artist = Flipper.Instant.new(0);
        })
        self.motor:step(0)
        self.motor:setGoal({
            title = Flipper.Spring.new(1, {
                frequency = 2;
                dampingRatio = 2.5;
            });
            artist = Flipper.Spring.new(1, {
                frequency = 2.5;
                dampingRatio = 2.5;
            });
        })
    end
end

function SongInfoDisplay:didMount()
    self.motor:setGoal({
        title = Flipper.Spring.new(1, {
            frequency = 4;
            dampingRatio = 2.5;
        });
        artist = Flipper.Spring.new(1, {
            frequency = 2.5;
            dampingRatio = 2.5;
        });
    })
end

function SongInfoDisplay:render()
    if self.props.SongKey == nil then
        return e(RoundedTextLabel, {
            Position = self.props.Position,
            Size = self.props.Size,
            AnchorPoint = self.props.AnchorPoint,
            Text = "Please select a map.",
            TextColor3 = Color3.fromRGB(221, 85, 85)
        })
    end
    
    local total_notes, total_holds = SongDatabase:get_note_metrics_for_key(self.props.SongKey)
    return e(RoundedFrame, {
        Position = self.props.Position,
        Size = self.props.Size,
        AnchorPoint = self.props.AnchorPoint,
    }, {
        SongCover = e(RoundedImageLabel, {
            Size = UDim2.fromScale(1, 1),
            ScaleType = Enum.ScaleType.Crop,
            Image = SongDatabase:get_image_for_key(self.props.SongKey),
            BackgroundTransparency = 1;
            ZIndex = 0
        }, {
            Gradient = e("UIGradient", {
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(0.75, 0.9),
                    NumberSequenceKeypoint.new(1, 1),
                });
                Rotation = -180;
            }),
        }),
        Corner = e("UICorner", {
            CornerRadius = UDim.new(0, 4),
        }),
        SongDataContainer = e(RoundedFrame, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.02, 0, 0.035, 0),
            Size = UDim2.new(1, 0, 0.5, 0),
        }, {
            UIListLayout = e("UIListLayout"),
            ArtistDisplay = e(RoundedTextLabel, {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 1,
                Size = UDim2.new(0.75, 0, 0.5, 0);
                TextTransparency = self.motorBinding:map(function(a)
                    return 1-a.artist
                end);
                Font = Enum.Font.Gotham,
                Text = SongDatabase:get_artist_for_key(self.props.SongKey),
                TextColor3 = Color3.fromRGB(255, 187, 14),
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                TextSizeConstraint = e("UITextSizeConstraint", {
                    MaxTextSize = 60,
                })
            }),
            TitleDisplay = e(RoundedTextLabel, {
                BackgroundTransparency = 1,
                Size = UDim2.new(0.75, 0, 0.3, 0);
                TextTransparency = self.motorBinding:map(function(a)
                    return 1-a.title
                end);
                Text = string.format("%s [%0.2fx Rate]", SongDatabase:get_title_for_key(self.props.SongKey), self.props.SongRate / 100),
                TextColor3 = Color3.fromRGB(255, 187, 14),
                TextScaled = true,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MaxTextSize = 40,
                })
            })
        }),
        NpsGraph = e(NpsGraph, {
            Size = UDim2.fromScale(0.3, 0.45),
            Position = UDim2.fromScale(0.99, 0.925),
            AnchorPoint = Vector2.new(1, 1),
            BackgroundTransparency = 1,
            SongKey = self.props.SongKey,
            SongRate = self.props.SongRate
        }),
        SongMapDataContainer = e(RoundedFrame, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.025, 0, 0.78, 0),
            Size = UDim2.new(1, 0, 0.45, 0),
            AnchorPoint = Vector2.new(0, 0.5)
        }, {
            UIListLayout = e("UIGridLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                FillDirection = Enum.FillDirection.Horizontal,
                FillDirectionMaxCells = 2,
                CellSize = UDim2.fromScale(0.1, 0.3)
            }),
            DifficultyDisplay = e(RoundedTextLabel, {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 1,
                TextTransparency = self.motorBinding:map(function(a)
                    return 1-a.title
                end);
                Size = UDim2.new(0.18, 0, 0.23, 0),
                Font = Enum.Font.GothamSemibold,
                Text = string.format("Difficulty: %d", SongDatabase:get_difficulty_for_key(self.props.SongKey)),
                TextColor3 = Color3.fromRGB(216, 216, 216),
                TextScaled = true,
                TextSize = 30,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MaxTextSize = 22,
                })
            }),
            TotalNotesDisplay = e(RoundedTextLabel, {
                TextColor3 = Color3.fromRGB(216, 216, 216),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 2,
                TextTransparency = self.motorBinding:map(function(a)
                    return 1-a.title
                end);
                Size = UDim2.new(0.18, 0, 0.23, 0),
                Font = Enum.Font.GothamSemibold,
                Text = string.format("Total Notes: %d", total_notes),
                TextScaled = true,
                TextSize = 30,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MaxTextSize = 22,
                })
            }),
            TotalHoldsDisplay = e(RoundedTextLabel, {
                TextColor3 = Color3.fromRGB(216, 216, 216),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 3,
                Position = self.motorBinding:map(function(a)
                    return UDim2.new(0.05*(1-a.artist), 0, 0.9, 0)
                end),
                TextTransparency = self.motorBinding:map(function(a)
                    return 1-a.title
                end);
                Size = UDim2.new(0.18, 0, 0.23, 0),
                Font = Enum.Font.GothamSemibold,
                Text = string.format("Total Holds: %d", total_holds),
                TextScaled = true,
                TextSize = 30,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MaxTextSize = 22,
                })
            }),
            TotalLengthDisplay = e(RoundedTextLabel, {
                TextColor3 = Color3.fromRGB(216, 216, 216),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = 4,
                Position = self.motorBinding:map(function(a)
                    return UDim2.new(0.05*(1-a.artist), 0, 0.35, 0)
                end),
                TextTransparency = self.motorBinding:map(function(a)
                    return 1-a.title
                end);
                Size = UDim2.new(0.18, 0, 0.23, 0),
                Font = Enum.Font.GothamSemibold,
                Text = string.format("Total Length: %s", SPUtil:format_ms_time(SongDatabase:get_song_length_for_key(self.props.SongKey) / (self.props.SongRate / 100))),
                TextScaled = true,
                TextSize = 30,
                TextXAlignment = Enum.TextXAlignment.Left,
            }, {
                UITextSizeConstraint = e("UITextSizeConstraint", {
                    MaxTextSize = 22,
                })
            });
        })
    })
end

return SongInfoDisplay