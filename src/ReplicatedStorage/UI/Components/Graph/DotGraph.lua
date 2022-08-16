local Roact = require(game.ReplicatedStorage.Packages.Roact)
local e = Roact.createElement
local f = Roact.createFragment
local SPList = require(game.ReplicatedStorage.Shared.SPList)
local SPUtil = require(game.ReplicatedStorage.Shared.SPUtil)

local Line = require(script.Parent.Line)

local DotGraph = Roact.Component:extend("DotGraph")

DotGraph.defaultProps = {
    formatPoint = function(point)
        return point
    end
}

function DotGraph:render()
    local dots = SPList:new()
    local lines = SPList:new()

    local data_points = self.props.points or {}

    local max_x = 0
    local max_y = 0

    for _, data_point in ipairs(data_points) do
        local point = self.props.formatPoint(data_point)
        max_x = math.abs(math.max(math.abs(point.x), max_x))

        if point.y then
            max_y = math.abs(math.max(math.abs(point.y), max_y))
        end
    end

    for _, data_point in ipairs(data_points) do
        local point = self.props.formatPoint(data_point)

        if point.line then
            local _element = e("Frame", {
                Position = UDim2.fromScale(point.x, 0);
                Size = UDim2.new(0, 1, 1, 0);
                AnchorPoint = Vector2.new(0.5, 0);
                BackgroundTransparency = 0.8;
                ZIndex = -1;
                BorderSizePixel = 0;
                BackgroundColor3 = point.color;
            })
            
            dots:push_back(_element)
        else
            local _element = e("Frame", {
                Position = UDim2.new(point.x, 0, point.y, 0);
                Size = UDim2.new(0,3,0,3);
                BorderSizePixel = 0;
                ZIndex = 2;
                BackgroundColor3 = point.color;
            })

            dots:push_back(_element)
        end
    end

    local bounds = self.props.bounds

    if bounds and bounds.min and bounds.max then
        if bounds.min.y and bounds.max.y then
            local y_int = self.props.interval and self.props.interval.y or 10
            for y = bounds.min.y, bounds.max.y, y_int do
                if y ~= bounds.min.y and y ~= bounds.max.y then
                    local _element = e(Line, {
                        value = y;
                        position = SPUtil:inverse_lerp(bounds.min.y, bounds.max.y, y);
                    })
                    lines:push_back(_element)
                end
            end
        end
    end

    return e("Frame", {
        Size = self.props.Size or UDim2.new(1,0,1,0);
        Position = self.props.Position;
        BackgroundColor3 = self.props.BackgroundColor3 or Color3.fromRGB(35, 35, 35);
        BorderSizePixel = self.props.BorderSizePixel or 0;
        AnchorPoint = self.props.AnchorPoint
    }, {
        Corner = e("UICorner", {
            CornerRadius = UDim.new(0,4)
        });
        DotElements = f(dots._table);
        LineElements = f(lines._table)
    })
end

return DotGraph