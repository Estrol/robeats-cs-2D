local Roact = require(game.ReplicatedStorage.Packages.Roact)
local RoactRodux = require(game.ReplicatedStorage.Packages.RoactRodux)
local e = Roact.createElement

local withInjection = require(game.ReplicatedStorage.UI.Components.HOCs.withInjection)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)
local RoundedAutoScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedAutoScrollingFrame)
local RoundedTextButton = require(game.ReplicatedStorage.UI.Components.Base.RoundedTextButton)

local Player = require(script.Player)

local Room = Roact.Component:extend("Room")

function Room:init()
    
end

function Room:render()
    local players = {}

    local room = self.props.room

    for i, player in ipairs(room.players) do
        players[i] = e(Player, {
            Name = player.Name,
            UserId = player.UserId
        })
    end

    return e(RoundedFrame, {
    
    }, {
        BackButton = e(RoundedTextButton, {
            Size = UDim2.fromScale(0.05, 0.05),
            HoldSize = UDim2.fromScale(0.06, 0.06),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.04, 0.95),
            BackgroundColor3 = Color3.fromRGB(212, 23, 23),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Text = "Back",
            TextSize = 12,
            OnClick = function()
                self.props.multiplayerService:LeaveRoom(self.props.roomId)
                self.props.history:goBack()
            end
        }),
        Players = e(RoundedAutoScrollingFrame, {
            Size = UDim2.fromScale(0.567, 0.95),
            Position = UDim2.fromScale(0.01, 0.01)
        }, players)
    })
end

local Injected = withInjection(Room, {
    multiplayerService = "MultiplayerService"
})

return RoactRodux.connect(function(state, props)
    return {
        room = state.multiplayer.rooms[props.location.state.roomId],
        roomId = props.location.state.roomId
    }
end)(Injected)