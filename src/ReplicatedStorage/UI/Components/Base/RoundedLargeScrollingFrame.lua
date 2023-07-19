-- TODO: fix glitchy look lol

local Roact = require(game.ReplicatedStorage.Packages.Roact)

local ListLayout = require(game.ReplicatedStorage.UI.Components.Layout.ListLayout)

local RoundedScrollingFrame = require(game.ReplicatedStorage.UI.Components.Base.RoundedScrollingFrame)

local RoundedLargeScrollingFrame = Roact.Component:extend("RoundedLargeScrollingFrame")

-- TODO: FIX ASPECT RATIO SCALING

--[[
    startIndex = floor(scrollPosition / elementHeight)
    endIndex = ceil((scrollPosition + scrollSize) / elementHeight)
]]

RoundedLargeScrollingFrame.defaultProps = {
    items = {},
    getItemSize = function()
        return 50
    end,
    renderItem = function()
        return nil
    end,
    Padding = UDim.new(0, 0)
}

function RoundedLargeScrollingFrame:init()
    self:setState({
        startIndex = 1;
        endIndex = 1;
    })

    self.recalcIndexes = function(songList)
        local itemSize = 0

        if self.props.AspectRatio then
            itemSize = songList.AbsoluteSize.X / self.props.AspectRatio
        else
            itemSize = self.props.getItemSize()            
        end

        local scrollPosition = songList.CanvasPosition
        local startIndex = math.floor(scrollPosition.Y / itemSize)+1;
        local endIndex = math.ceil((scrollPosition.Y + songList.AbsoluteSize.Y + self.props.Padding.Offset) / itemSize);

        if (startIndex ~= self.state.startIndex) or (endIndex ~= self.state.endIndex) then
            self:setState({
                startIndex = startIndex;
                endIndex = endIndex;
            })
        end
    end

    self.listRef = self.props[Roact.Ref] or Roact.createRef()
end

function RoundedLargeScrollingFrame:render()
    local children = {}
    
    for i = self.state.startIndex, self.state.endIndex do
        local key

        if self.props.getStableId then
            key = self.props.getStableId(self.props.items[i], i)
        else
            key = i
        end

        key = key or i

        if self.props.items[i] ~= nil then
            children[string.format("[%s]", key)] = self.props.renderItem(self.props.items[i], i)
        end
    end

    return Roact.createElement(RoundedScrollingFrame, {
        BackgroundTransparency = self.props.BackgroundTransparency;
        Position = self.props.Position,
        Size = self.props.Size,
        CanvasSize = UDim2.fromOffset(0, (self.props.getItemSize() * #self.props.items) + self.props.Padding.Offset),
        ScrollBarThickness = self.props.ScrollBarThickness,
        [Roact.Ref] = self.listRef,
        [Roact.Change.CanvasPosition] = self.recalcIndexes;
        [Roact.Change.AbsoluteSize] = self.recalcIndexes;
    }, {
        ScrollingFrameLayout = Roact.createElement(ListLayout, {
            Padding = self.props.Padding,
            StartAt = (self.state.startIndex-1) * self.props.getItemSize(),
            HorizontalAlignment = self.props.HorizontalAlignment,
        }, children)
    })
end

return RoundedLargeScrollingFrame