local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement

local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedAutoScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedAutoScrollingFrame)
local RoundedTextLabel = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextLabel)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local Room = Roact.Component:extend("Room")

Room.defaultProps = {
    Name = "Room",
    Players = {},
    SongKey = 1,
    OnJoinClick = function()
    
    end
}

function Room:render()
    local hostName = self.props.Host and self.props.Host.Name or "Player"

    return e(RoundedFrame, {
        Size = UDim2.new(1, 0, 0, 110),
        BackgroundColor3 = Color3.fromRGB(26, 25, 25)
    }, {
        Name = e(RoundedTextLabel, {
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(255, 208, 87),
            TextScaled = true,
            Position = UDim2.fromScale(0.015, 0.04),
            Size = UDim2.fromScale(1, 0.35),
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = self.props.Name
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 60
            })
        }),
        Info = e(RoundedTextLabel, {
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(226, 226, 226),
            TextScaled = true,
            Position = UDim2.fromScale(0.015, 0.327),
            Size = UDim2.fromScale(1, 0.35),
            TextXAlignment = Enum.TextXAlignment.Left,
            Text = string.format("Host: %s, Number of Players: %d", hostName, #self.props.Players)
        }, {
            UITextSizeConstraint = e("UITextSizeConstraint", {
                MaxTextSize = 19
            })
        }),
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
        JoinButton = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.075, 0.2),
            HoldSize = UDim2.fromScale(0.06, 0.06),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.953, 0.82),
            BackgroundColor3 = Color3.fromRGB(35, 65, 44),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Join",
            TextSize = 15,
            ZIndex = 2,
            OnClick = function()
                if self.props.RoomId then
                    self.props.history:push("/room", {
                        roomId = self.props.RoomId
                    })
                end
            end
        }),
    })
end

return Room