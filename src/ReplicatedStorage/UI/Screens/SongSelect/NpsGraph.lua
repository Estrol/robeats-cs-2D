local SongDatabase = require(game.ReplicatedStorage.RobeatsGameCore.SongDatabase)

local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

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

function NpsGraph:GetNpsGraphColor(nps)
	local x = 0
	if nps < 7 then
		x = nps/7
		return Color3.new(0.1 + x * 0.1, 0.1 + x * 0.1, 0.8 + x * 0.2)
	elseif nps < 14 then
		x = (nps - 7) / 7
		return Color3.new(0.2 + 0.4 * x, 0.2 + 0.2 * x, 1.0)
	elseif nps < 21 then
		x = (nps - 14) / 7
		return Color3.new(0.6 + 0.4 * x, 0.4 - 0.2 * x, 1.0 - 0.3 * x)
	elseif nps < 28 then
		x = (nps - 21) / 7
		return Color3.new(1.0, 0.2 + 0.2 * x, 0.7 - 0.5 * x)
	elseif nps < 35 then
		x = (nps - 28) / 7
		return Color3.new(1.0, 0.4 - 0.3 * x, 0.2 - 0.15 * x)
	elseif nps < 42 then
		x = (nps - 35) / 7
		return Color3.new(1.0- 0.3 * x, 0.1 - x * 0.1, 0.05 - 0.05 * x)
	else
		return Color3.new(0.7, 0.0, 0.0)
	end
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
                return self:GetNpsGraphColor(nps * (a / 100))
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