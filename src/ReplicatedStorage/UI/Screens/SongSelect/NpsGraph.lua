local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local RoundedFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedFrame)

local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Flipper = require(game.ReplicatedStorage.Packages.Flipper)
local RoactFlipper = require(game.ReplicatedStorage.Packages.RoactFlipper)
local e = Roact.createElement
local f = Roact.createFragment

local NpsGraph = Roact.Component:extend("NpsGraph")

NpsGraph.defaultProps = {
    SongKey = 1,
    SongRate = 100,
    Size = UDim2.fromScale(1, 1)
}

function NpsGraph:init()
    self.motor = Flipper.SingleMotor.new(self.props.SongRate)
    self.motorBinding = RoactFlipper.getBinding(self.motor)
end

function NpsGraph:get_ideal_resolution_for_length()
    local length = SongDatabase:get_song_length_for_key(self.props.SongKey)

    return math.clamp(math.floor(length / 100000), 1, math.huge)
end

function NpsGraph:didUpdate()
    self.motor:setGoal(Flipper.Spring.new(self.props.SongRate, {
        frequency = 12,
        dampingRatio = 2.5
    }))
end

function NpsGraph:render()
    local graph = SongDatabase:get_nps_graph_for_key(self.props.SongKey, self:get_ideal_resolution_for_length())

    local points = {}

    for i, nps in ipairs(graph) do
        local point = e(RoundedFrame, {
            Size = self.motorBinding:map(function(a)
                return UDim2.fromScale(1 / #graph, (nps*(a / 100)) / 42)
            end),
            AnchorPoint = Vector2.new(0, 1),
            LayoutOrder = i,
            ZIndex = 2,
            BackgroundColor3 = self.motorBinding:map(function(a)
                return Color3.fromRGB(15, 194, 155):Lerp(Color3.fromRGB(243, 28, 12), (nps * (a / 100)) / 42)
            end)
        })

        table.insert(points, point)
    end

    return e(RoundedFrame, {
        Size = self.props.Size,
        Position = self.props.Position,
        AnchorPoint = self.props.AnchorPoint,
        BackgroundTransparency = self.props.BackgroundTransparency,
        ClipsDescendants = true
    }, {
        Points = f(points),
        UIListLayout = e("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom
        })
    })
end

return NpsGraph